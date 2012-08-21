unit UFileProperty;

interface

uses
  Windows, SysUtils, IniFiles, Forms, Graphics, Classes, Dialogs,
  Menus, ComCtrls, Controls, Registry, ShellApi,
  SynMemo, SynEdit, XMLDoc, XMLIntf, SynEditHighlighter, SynEditKeyCmds,
  Makefile, Breakpoint, UTemplates, ModernTabs;

const
  FILE_TYPE_PROJECT = 1;
  FILE_TYPE_C       = 2;
  FILE_TYPE_CPP     = 3;
  FILE_TYPE_H       = 4;
  FILE_TYPE_RC      = 5;
  FILE_TYPE_UNKNOW  = 6;
  FILE_TYPE_FOLDER  = 7;

  SHEET_TYPE_FILE  = 1;
  SHEET_TYPE_DESGN = 2;

  FILE_IMG_LIST: array[1..7] of Integer = (1, 2, 3, 4, 5, 6, 0);

  USER_DEFINED = -2;
  NO_COMPILER  = -1;
  COMPILER_C   =  0;
  COMPILER_CPP =  1;
  COMPILER_RC  =  2;
  COMPILERS: array[0..2] of String = (
    'C',
    'CPP',
    'RC'
  );

  APPTYPE_CONSOLE = 0;
  APPTYPE_GUI     = 1;
  APPTYPE_DLL     = 2;
  APPTYPE_LIB     = 3;
  APPTYPE_FTM     = 4;
  APPTYPE_FPK     = 5;
  APPTYPES: array[0..5] of String = (
    'CONSOLE',
    'GUI',
    'DLL',
    'LIB',
    'FTM',
    'FPK'
  );

  APPEXTTYPES: array[0..5] of String = (
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
    CompanyName: String;
    FileVersion: String;
    FileDescription: String;
    InternalName: String;
    LegalCopyright: String;
    LegalTrademarks: String;
    OriginalFilename: String;
    ProductName: String;
    ProductVersion: String;
  end;

  TFilePropertySheet = class;
  TProjectProperty = class;

  TFileProperty = class
  private
    FFileDateTime: TDateTime;
    FFileName: String;
    FFileType: Integer;
    FEditor: Pointer;
    FNode: Pointer;
    FProject: Pointer;
    FSaved: Boolean;
    FModified: Boolean;
    FBreakpoint: TBreakpointList;
    function GetCaption: String;
    function GetNode: TTreeNode;
    function GetEditor: TModernPageControl;
    function GetProject: TProjectProperty;
    function GetModified: Boolean;
    procedure SetProject(Value: TProjectProperty);
    procedure SetFileType(Value: Integer);
    procedure SetFileName(Value: String);
  public
    function DeleteOfDisk: Boolean;
    function Delete: Boolean;
    function Edit(SelectTab: Boolean = True): TFilePropertySheet;
    function Editing: Boolean;
    function ViewPage: Boolean;
    function Rename(new_name: String): Boolean;
    procedure LoadFile(Text: TStrings);
    function GetSheet(var Sheet: TFilePropertySheet): Boolean;
    function Open: Boolean;
    function Close: Boolean;
    function Save: Boolean;
    function GetCompleteFileName: String;
    function FindFile(const Name: String; var FileProp: TFileProperty): Boolean;
    function FileChangedInDisk: Boolean;
    procedure Reload;
    procedure UpdateDate;
    procedure Assign(Value: TFileProperty);
    constructor Create(Editor, Node: Pointer);
    destructor Destroy; override;
  published
    property FileName: String read FFileName write SetFileName;
    property Caption: String read GetCaption;
    property DateOfFile: TDateTime read FFileDateTime write FFileDateTime;
    property FileType: Integer read FFileType write SetFileType;
    property Modified: Boolean read GetModified write FModified;
    property Saved: Boolean read FSaved write FSaved;
    property Node: TTreeNode read GetNode;
    property PageCtrl: TModernPageControl read GetEditor;
    property Project: TProjectProperty read GetProject write SetProject;
    property Breakpoint: TBreakpointList read FBreakpoint;
  end;

  TProjectProperty = class(TFileProperty)
  private
    FTargetDateTime: TDateTime;
    FLibs: String;
    FTemplateResources: TTemplateID;
    FFlags: String;
    FCompOpt: String;
    FTarget: String;
    FCompilerPath: String;
    FCmdLine: String;
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
    FIconFileName: String;
    FIcon: TIcon;
    FAutoIncBuild: Boolean;
    FPropertyChanged: Boolean;
    FCompilerPropertyChanged: Boolean;
    FDebugging: Boolean;
    FVersion: TVersionInfo;
    FBreakpointChanged: Boolean;
    FBreakpointCursor: TBreakpoint;
    FForceClean: Boolean;//for header changes
    procedure SetIcon(Value: TIcon);
  public
    property TemplateResources: TTemplateID read FTemplateResources
                                            write FTemplateResources;
    property Version: TVersionInfo read FVersion;
    property BreakpointCursor: TBreakpoint read FBreakpointCursor;
    constructor Create(Editor, Node: Pointer);
    destructor Destroy; override;
    function SaveAll(SavePrjFile: Boolean = False): Boolean;
    function CloseAll: Boolean;
    function GetFileByPathName(const RelativeName: String): TFileProperty;
    function LoadFromFile(const AFileName: String): Boolean;
    function LoadLayout: Boolean;
    function SaveLayout: Boolean;
    function SaveToFile(const AFileName: String): Boolean;
    function GetResource(Res: TStrings): Boolean;
    function GetFiles(AllTypes: Boolean = False;
      WithBreakpoint: Boolean = False): TStrings;
    function Build(Run: Boolean = False): Boolean;
    function SaveAs(const AFileName: String): Boolean;
    function NeedBuild: Boolean;
    function GetTarget: String;
    function FilesChanged: Boolean;
    function TargetChanged: Boolean;
    function GetBreakpointLists(List: TStrings): Boolean;
    function HasBreakpoint: Boolean;
  published
    property ForceClean: Boolean read FForceClean write FForceClean;
    property Debugging: Boolean read FDebugging write FDebugging;
    property Libs: String read FLibs write FLibs;
    property Flags: String read FFlags write FFlags;
    property CompilerOptions: String read FCompOpt write FCompOpt;
    property Target: String read FTarget write FTarget;
    property CompilerPath: String read FCompilerPath write FCompilerPath;
    property CmdLine: String read FCmdLine write FCmdLine;
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
    property IconFileName: String read FIconFileName write FIconFileName;
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

  TFilePropertySheet = class(TPropertySheet)
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

{TFileProperty}
constructor TFileProperty.Create(Editor, Node: Pointer);
begin
  inherited Create;
  FBreakpoint := TBreakpointList.Create;
  FEditor := Editor;
  FBreakpoint.ImageList := FrmFalconMain.ImageListGutter;
  FBreakpoint.ImageIndex := 2;
  FBreakpoint.InvalidIndex := 3;
  FNode := Node;
  FFileType := FILE_TYPE_UNKNOW;
  FModified := False;
  FSaved := False;
end;

destructor TFileProperty.Destroy;
begin
  FBreakpoint.Free;
  inherited Destroy;
end;

function TFileProperty.GetCaption: String;
begin
  if (FileType = FILE_TYPE_PROJECT) then
    Result := ExtractName(FFileName)
  else
    Result := ExtractFileName(FFileName);
end;

function TFileProperty.GetNode: TTreeNode;
begin
  Result := TTreeNode(FNode);
end;

function TFileProperty.GetEditor: TModernPageControl;
begin
  Result := TModernPageControl(FEditor);
end;

//partial
function TFileProperty.DeleteOfDisk: Boolean;
begin
  if (FFileType <> FILE_TYPE_FOLDER) then
  begin
    if FileExists(GetCompleteFileName) then
    begin
      Result := DeleteFile(GetCompleteFileName);
      if Result then Delete;
    end
    else
      Result := Delete;
  end
  else
  begin
    if DirectoryExists(GetCompleteFileName) then
    begin
      Result := RemoveDir(GetCompleteFileName);
      if Result then Delete;
    end
    else
      Result := Delete;
  end;
end;

function TFileProperty.FileChangedInDisk: Boolean;
var
  FileDate: TDateTime;
begin
  Result := False;
  if (FileType = FILE_TYPE_FOLDER) then Exit;

  if FileExists(GetCompleteFileName) and Saved then
  begin
    FileDate := FileDateTime(GetCompleteFileName);
    Result := (FileDate <> FFileDateTime);
  end;
end;

procedure TFileProperty.Reload;
var
  sheet: TFilePropertySheet;
begin
  if (FileType = FILE_TYPE_FOLDER) then Exit;
  if FileExists(GetCompleteFileName) and Saved then
  begin
    if GetSheet(sheet) then
      LoadFile(sheet.Memo.Lines);
    UpdateDate;
  end;
end;

procedure TFileProperty.UpdateDate;
var
  FileDate: TDateTime;
begin
  if (FileType = FILE_TYPE_FOLDER) then Exit;
  if FileExists(GetCompleteFileName) and Saved then
  begin
    FileDate := FileDateTime(GetCompleteFileName);
    FFileDateTime := FileDate;
  end;
end;

function TFileProperty.FindFile(const Name: String;
  var FileProp: TFileProperty): Boolean;
var
  I: Integer;
  fp: TFileProperty;
begin
  Result := False;
  for I := 0 to Node.Count - 1 do
  begin
    fp := TFileProperty(Node.Item[I].Data);
    if CompareText(fp.GetCaption, Name) = 0 then
    begin
      FileProp := fp;
      Result := True;
      Exit;
    end;
  end;
end;

function TFileProperty.GetCompleteFileName: String;
var
  Parent: TFileProperty;
begin
  if (Self is TProjectProperty) or not assigned(Node.Parent) then
    Result := FileName
  else
  begin
    Parent := TFileProperty(Node.Parent.Data);
    if (FileType = FILE_TYPE_FOLDER) then
      Result := ExtractFilePath(Parent.GetCompleteFileName) + FileName + '\'
    else
      Result := ExtractFilePath(Parent.GetCompleteFileName) + FileName;
  end;
end;

function TFileProperty.Delete: Boolean;
var
  I: Integer;
begin
  if (FileType = FILE_TYPE_FOLDER) or (FileType = FILE_TYPE_PROJECT) then
  begin
    for I := TTreeNode(FNode).Count - 1 downto 0 do
      TFileProperty(TTreeNode(FNode).Item[I].Data).Delete;
  end
  else
    Close;
  if Assigned(FNode) then
    TTreeNode(FNode).Delete;
  Project.PropertyChanged := True;
  Result := True;
  Free;
end;

procedure TFileProperty.Assign(Value: TFileProperty);
begin
  if not assigned(Value) then Exit;
  FFileDateTime := Value.FFileDateTime;
  FFileName := Value.FFileName;
  FFileType := Value.FFileType;
  FEditor := Value.FEditor;
  FNode := Value.FNode;
  FProject := Value.FProject;
  FSaved := Value.FSaved;
  FModified := Value.FModified;
end;

function TFileProperty.GetProject: TProjectProperty;
begin
  Result := TProjectProperty(FProject);
end;

procedure TFileProperty.SetProject(Value: TProjectProperty);
begin
  if (Value <> FProject) then
    FProject := Value;
end;

procedure TFileProperty.SetFileName(Value: String);
var
  Temp: String;
begin
  if (FileType <> FILE_TYPE_FOLDER) then
  begin
    if ExtractFileName(Value) <> ExtractFileName(GetCompleteFileName) then
    begin
      if FileExists(GetCompleteFileName) then
      begin
        FrmFalconMain.RenameFileInHistory(GetCompleteFileName,
          ExtractFilePath(GetCompleteFileName) + ExtractFileName(Value));
        RenameFile(GetCompleteFileName,
          ExtractFilePath(GetCompleteFileName) + ExtractFileName(Value));
      end;
      if Self is TProjectProperty then
      begin
        if(Project.AppType = APPTYPE_LIB)then
        begin
          if CompareText('lib'+ExtractName(FileName),
            ExtractName(Project.Target)) = 0 then
          begin
            Project.Target := 'lib'+ExtractName(Value) + ExtractFileExt(Project.Target);
            if Project.Saved then
              Project.PropertyChanged := True;
          end;
        end
        else
        begin
          if CompareText(ExtractName(FileName),
            ExtractName(Project.Target)) = 0 then
          begin
            Project.Target := ExtractName(Value) + ExtractFileExt(Project.Target);
            if Project.Saved then
              Project.PropertyChanged := True;
          end;
        end;
      end
      else
      begin
        Project.Modified := True;
      end;
    end;
  end
  else
  begin
    if Value <> FileName then
    begin
      Temp := GetCompleteFileName;
      FFileName := Value;
      if DirectoryExists(Temp) then
        RenameFile(Temp, GetCompleteFileName);
      Project.Modified := True;
    end;
  end;
  FFileName := Value;
  Node.Text := Caption;
end;

procedure TFileProperty.SetFileType(Value: Integer);
var
  Sheet: TFilePropertySheet;
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

function TFileProperty.Edit(SelectTab: Boolean): TFilePropertySheet;
var
  Sheet: TFilePropertySheet;
begin
  if GetSheet(Sheet) then
  begin
    Result := Sheet;
    ViewPage;
    if Sheet.Memo.Showing then
      Sheet.Memo.SetFocus;
    Exit;
  end;
  Sheet := TFilePropertySheet.CreateEditor(Node, PageCtrl, SelectTab);
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

function TFileProperty.Open: Boolean;
begin
  Result := False;
  if (FFileType = FILE_TYPE_FOLDER) then
  begin
    if DirectoryExists(GetCompleteFileName) then
      ShellExecute(0, 'open', PChar(GetCompleteFileName), nil, nil, SW_SHOW);
  end
  else
  begin
    if FileExists(GetCompleteFileName) then
      ShellExecute(0, 'open', 'explorer.exe',
      PChar('/select, "' + GetCompleteFileName + '"'), nil, SW_SHOW);
    //Edit;
  end;
end;

function TFileProperty.Rename(new_name: String): Boolean;
var
  OldName: String;
begin
  OldName := GetCompleteFileName;
  SetFileName(new_name);
  Result := (OldName <> GetCompleteFileName);
  if Result then
  begin
    Project.CompilePropertyChanged := True;
    Project.PropertyChanged := True;
  end;
end;

procedure TFileProperty.LoadFile(Text: TStrings);
begin
  Text.LoadFromFile(GetCompleteFileName);
end;

function TFileProperty.GetSheet(var Sheet: TFilePropertySheet): Boolean;
var
  I: Integer;
  ASheet: TFilePropertySheet;
begin
  Result := False;
  for I:= 0 to Pred(PageCtrl.PageCount) do
  begin
    ASheet := TFilePropertySheet(PageCtrl.Pages[I]);
    if (ASheet.Node = Node) then
    begin
      Sheet := ASheet;
      Result := True;
      Exit;
    end;
  end;
end;

function TFileProperty.ViewPage: Boolean;
var
  I: Integer;
  Sheet: TFilePropertySheet;
begin
  Result := False;
  for I:= 0 to Pred(PageCtrl.PageCount) do
  begin
    Sheet := TFilePropertySheet(PageCtrl.Pages[I]);
    if (Sheet.Node = Node) then
    begin
      if (Sheet.PageIndex <> PageCtrl.ActivePageIndex) then
        PageCtrl.ActivePageIndex := I;
      Result := True;
      Exit;
    end;
  end;
end;

function TFileProperty.Editing: Boolean;
var
  I: Integer;
  Sheet: TFilePropertySheet;
begin
  Result := False;
  for I:= 0 to Pred(PageCtrl.PageCount) do
  begin
    Sheet := TFilePropertySheet(PageCtrl.Pages[I]);
    if (Sheet.Node = Node) then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

function TFileProperty.GetModified: Boolean;
var
  FileDate: TDateTime;
  Sheet: TFilePropertySheet;
  ProjProp: TProjectProperty;
begin
  if (FileType = FILE_TYPE_FOLDER) then
  begin
    FModified := not DirectoryExists(GetCompleteFileName);
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
  //if saved then verify if file exist and if date are equals
  //if Saved or FileExists(GetCompleteFileName) then
  if Saved then
  begin
    FModified := not FileExists(GetCompleteFileName);
    if not FModified then
    begin
      FileDate := FileDateTime(GetCompleteFileName);
      FModified := (FileDate <> FFileDateTime);
    end;
  end;
  //set project modified?
  if FModified then
    Project.Modified := True;
  Result := FModified;
end;

function TFileProperty.Close: Boolean;
var
  Sheet: TFilePropertySheet;
begin
  Result := False;
  if GetSheet(Sheet) then
  begin
    if (Sheet.PageIndex = Pred(GetEditor.PageCount ))
        and (Sheet.PageIndex > 0) then
      GetEditor.ActivePageIndex := Sheet.PageIndex - 1;
    Sheet.Free;
    if not (GetEditor.PageCount > 0) then GetEditor.Hide;
    Result := True;
  end;
end;

function TFileProperty.Save: Boolean;
var
  Sheet: TFilePropertySheet;
  CanSaveFile: Boolean;
begin
  if Project.Saved then
    FSaved := True;
  CanSaveFile := False;
  if FSaved then
  begin
    if (FileType <> FILE_TYPE_FOLDER) then
    begin
      if Modified or not FileExists(GetCompleteFileName) or FileChangedInDisk then
        CanSaveFile := True;
    end
    else
      if not DirectoryExists(GetCompleteFileName) then
        CreateDir(GetCompleteFileName);
  end
  else
  begin//internal file
    if (FileType <> FILE_TYPE_FOLDER) then
    begin
      if Modified or not FileExists(GetCompleteFileName) or
         FileChangedInDisk or ((DateOfFile <> FileDateTime(GetCompleteFileName))) then
      begin
        CanSaveFile := True;
      end;
    end
    else
      if not DirectoryExists(GetCompleteFileName) then
          CreateDir(GetCompleteFileName);
  end;
  if CanSaveFile then
  begin
    Project.Compiled := False;
    if (FileType <> FILE_TYPE_PROJECT) then
    begin
      if GetSheet(Sheet) then
      begin
        Sheet.Memo.Lines.SaveToFile(GetCompleteFileName);
        sheet.Memo.Modified := False;
      end;
      if FSaved then
        Project.Modified := False;
      if FileType = FILE_TYPE_H then
        Project.ForceClean := True;
    end
    else
    begin
      TProjectProperty(Self).PropertyChanged := False;
      TProjectProperty(Self).SaveToFile(GetCompleteFileName);
    end;
    FFileDateTime := FileDateTime(GetCompleteFileName);
  end;
  FModified := False;
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
      Sheet.Caption := GetCaption;
    end;
  end;
  Result := True;
end;

{TProjectProperty}
constructor TProjectProperty.Create(Editor, Node: Pointer);
begin
  inherited Create(Editor, Node);
  FForceClean := False;//first compilation do clean?
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
  for I:= 0 to Pred(AllFiles.Count) do
    TFileProperty(AllFiles.Objects[I]).Close;
end;

function TProjectProperty.SaveAll(SavePrjFile: Boolean = False): Boolean;
var
  I: Integer;
  AllFiles: TStrings;
  S: String;
  Template: TTemplate;
  Resources: TTemplateResources;
begin
  Result := True;
  if not SavePrjFile then
  begin
    if not (FileType = FILE_TYPE_PROJECT) then Save;//save .c or .cpp file
  end
  else
  begin//save project file
    if Modified or not FileExists(GetCompleteFileName) then Save;
  end;
  //save all files with folders
  AllFiles := GetFiles(True);
  for I:= 0 to Pred(AllFiles.Count) do
    TFileProperty(AllFiles.Objects[I]).Save;
  //save template resources
  if Assigned(FTemplateResources) then
  begin
    Template := FrmFalconMain.Templates.Find(FTemplateResources);
    if Assigned(Template) then
    begin
      Resources := Template.Resources;
      for I := 0 to Resources.Count - 1 do
      begin
        S := ExtractFilePath(GetCompleteFileName) +
          Resources.ResourceName[I];
        Resources.SaveToFile(S, I);
      end;
    end;
    FTemplateResources.Free;
    FTemplateResources := nil;
  end;
end;

function TProjectProperty.SaveAs(const AFileName: String): Boolean;
begin
  FFileName := AFileName;
  Result := SaveAll(True);
end;

function TProjectProperty.GetTarget: String;
begin
  Result := ExtractFilePath(GetCompleteFileName) + Target;
end;

function TProjectProperty.LoadFromFile(const AFileName: String): Boolean;

  function GetTagProperty(Node: IXMLNode; Tag, Attribute: String): String;
  var
    Temp: IXMLNode;
  begin
    Temp := Node.ChildNodes.FindNode(Tag);
    if (Temp <> nil) then
      Result := Temp.Attributes[Attribute]
    else
      Result := '';
  end;

  procedure LoadFiles(XMLNode: IXMLNode; Parent: TFileProperty);
  var
    Temp: IXMLNode;
    NodeFileName: String;
    FileProp: TFileProperty;
  begin
    Temp := XMLNode.ChildNodes.First;
    while (Temp <> nil) do
    begin
      NodeFileName := Temp.Attributes['Name'];
      if (Temp.NodeName = 'Folder') then
      begin
        FileProp := NewFileProperty(FILE_TYPE_FOLDER, NO_COMPILER, NodeFileName,
          NodeFileName, '', '', Parent, True, False);
        FileProp.Modified := False;
        FileProp.Saved := True;
        LoadFiles(Temp, FileProp);
      end
      else if (Temp.NodeName = 'File') then
      begin
        FileProp := NewFileProperty(GetFileType(NodeFileName),
                    GetCompiler(GetFileType(NodeFileName)), NodeFileName,
                    RemoveFileExt(NodeFileName), ExtractFileExt(NodeFileName),
                    '', Parent, True, False);
        NodeFileName := FileProp.GetCompleteFileName;
        if FileExists(NodeFileName) then
        begin
          FileProp.DateOfFile := FileDateTime(NodeFileName);
          FileProp.Saved := True;
          FileProp.Modified := False;
        end
        else
        begin
          //file not found
          // TODO:
        end;
      end;
      Temp := Temp.NextSibling;
    end;
  end;

var
  XMLDoc: TXMLDocument;
  Node, ProjNode: IXMLNode;
  StrIcon, Temp: String;
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


function TProjectProperty.GetFileByPathName(const RelativeName: String): TFileProperty;
var
  Temp, S: String;
  Parent: TFileProperty;
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

  function GetTagProperty(Node: IXMLNode; Tag, Attribute: String;
    Default: String = ''): String;
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
  Temp, S, LytFileName: String;
  TopIndex, TopLine, Tabpos: Integer;
  FileProp: TFileProperty;
  sheet: TFilePropertySheet;
  CaretXY, BlockS_or_E: TBufferCoord;
  //List: TStrings; //for unascendent layout file
begin
  Result := False;
  LytFileName := ChangeFileExt(GetCompleteFileName, '.layout');
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

  procedure AddFile(const RelFileName: String; sheet: TFilePropertySheet);
  var
    I, Index, pi: Integer;
  begin
    Index := 0;
    for I := 0 to FileList.Count - 1 do
    begin
      pi := TFilePropertySheet(FileList.Objects[I]).PageIndex;
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

  procedure SetTagProperty(Node: IXMLNode; Tag, Attribute, Value: String);
  var
    Temp: IXMLNode;
  begin
    Temp := Node.ChildNodes.FindNode(Tag);
    if (Temp = nil) then
      Temp := Node.AddChild(Tag);
    Temp.Attributes[Attribute] := Value;
  end;

  procedure AddFiles(Parent: TFileProperty);
  var
    I: Integer;
    FileProp: TFileProperty;
    ProjPath, RelFileName: String;
    sheet: TFilePropertySheet;
  begin
    ProjPath := ExtractFilePath(GetCompleteFileName);
    for I:= 0 to Pred(Parent.Node.Count) do
    begin
      FileProp := TFileProperty(Parent.Node.Item[I].Data);
      RelFileName := ExtractRelativePath(ProjPath, FileProp.GetCompleteFileName);
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
  BoolStr: String;
  sheet: TFilePropertySheet;
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
      sheet := TFilePropertySheet(FileList.Objects[I]);
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
      XMLDoc.SaveToFile(ChangeFileExt(GetCompleteFileName, '.layout'))
    else
      DeleteFile(ChangeFileExt(GetCompleteFileName, '.layout'));
  except
    XMLDoc.Free;
    Result := False;
    Exit;
  end;
  XMLDoc.Free;
  Result := True;
end;

function TProjectProperty.SaveToFile(const AFileName: String): Boolean;

  procedure SetTagProperty(Node: IXMLNode; Tag, Attribute, Value: String);
  var
    Temp: IXMLNode;
  begin
    Temp := Node.ChildNodes.FindNode(Tag);
    if (Temp = nil) then
      Temp := Node.AddChild(Tag);
    Temp.Attributes[Attribute] := Value;
  end;

  procedure AddFiles(XMLNode: IXMLNode; Parent: TFileProperty);
  var
    Temp: IXMLNode;
    I: Integer;
    FileProp: TFileProperty;
  begin
    for I:= 0 to Pred(Parent.Node.Count) do
    begin
      FileProp := TFileProperty(Parent.Node.Item[I].Data);
      if (FileProp.FileType = FILE_TYPE_FOLDER) then
      begin
        Temp := XMLNode.AddChild('Folder');
        Temp.Attributes['Name'] := FileProp.Caption;
        AddFiles(Temp, FileProp);
      end
      else
      begin
        Temp := XMLNode.AddChild('File');
        Temp.Attributes['Name'] := FileProp.Caption;
      end;
    end;
  end;
  
var
  XMLDoc: TXMLDocument;
  Node, ProjNode: IXMLNode;
  Temp: String;
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
  FileProp: TFileProperty;
  List: TStrings;
begin
  Result := False;
  List := GetFiles;
  for I:= 0 to Pred(List.Count) do
  begin
    FileProp := TFileProperty(List.Objects[I]);
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
    fp: TFileProperty;
  begin
    fp := TFileProperty(ANode.Data);
    canAdd := (not (fp.FileType in [FILE_TYPE_RC, FILE_TYPE_FOLDER]) and
      WithBreakpoint and (fp.Breakpoint.Count > 0)) or not WithBreakpoint;
    if AllTypes then
    begin
      if canAdd then
        List.AddObject(fp.GetCompleteFileName, fp);
    end
    else
    begin
      if (TFileProperty(ANode.Data).FileType <> FILE_TYPE_FOLDER) then
      begin
        if canAdd then
          List.AddObject(fp.GetCompleteFileName, fp);
      end;
    end;
    if (ANode.Count > 0) then
    begin
      for X:= 0 to Pred(ANode.Count) do AddFiles(List, ANode.Item[X]);
    end;
  end;

var
  List: TStrings;
  I: Integer;
begin
  List := TStringList.Create;
  if (FileType = FILE_TYPE_PROJECT) then
    for I:= 0 to Pred(Node.Count) do
        AddFiles(List, Node.Item[I])
  else
  begin
    if (not (FileType in [FILE_TYPE_RC, FILE_TYPE_FOLDER]) and
      WithBreakpoint and (Breakpoint.Count > 0)) or not WithBreakpoint then
      List.AddObject(FileName, TFileProperty(Self));
  end;
  Result := List;
end;

function TProjectProperty.GetResource(Res: TStrings): Boolean;
var
  List: TStrings;
  I: Integer;
  Vers: String;
  Manf: Byte;
begin
  Result := False;
  List := GetFiles(True);
  for I:= 0 to Pred(List.Count) do
  begin
    if (TFileProperty(List.Objects[I]).FFileType = FILE_TYPE_RC) then
    begin
      Result := True;
      Res.Add('#include "' + ExtractRelativePath(ExtractFilePath(FileName),
              TFileProperty(List.Objects[I]).GetCompleteFileName + '"'));
    end;
  end;
  Manf := 0;
  if IncludeVersionInfo or Assigned(Icon) then Result := True;
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
        Vers := IntToStr(FVersion.Major)  + ',' +
                IntToStr(FVersion.Minor)  + ',' +
                IntToStr(FVersion.Release)  + ',' +
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
          IntToHex(FVersion.LanguageID, 4)+', 0x' + IntToHex(FVersion.CharsetID, 4));
        Res.Add('    END');
        Res.Add('END');
      end;
    end;
  end;
  List.Free;
end;

function TProjectProperty.Build(Run: Boolean = False): Boolean;

  procedure SaveManifest(AFileName, ResName: String);
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
  Makefile, FileContSpc, Temp: String;
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
    Debugging := HasBreakpoint  or BreakpointCursor.Valid;
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
      ForceClean := False;//WARNING if mingw32-make.exe not complete clean rule
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
  else
    if (CompilerType = COMPILER_RC) then
    begin
      Res := TStringList.Create;
      Temp := Caption;
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
      FrmFalconMain.CompilerCmd.Directory := ExtractFilePath(GetCompleteFileName);
      FrmFalconMain.CompilerCmd.Params := '-i "' + Temp + '" -J rc -o "' +
                                          Target + '" -O COFF';
      FrmFalconMain.CompilerCmd.Start;
    end;
end;

function TProjectProperty.GetBreakpointLists(List: TStrings): Boolean;
var
  I: Integer;
  files: TStrings;
  fprop: TFileProperty;
begin
  files := GetFiles(False, True);
  Result := files.Count > 0;
  for I := 0 to files.Count - 1 do
  begin
    fprop := TFileProperty(files.Objects[I]);
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
  FListView :=  TListView.Create(Self);
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

{TFilePropertySheet}
constructor TFilePropertySheet.CreateEditor(Node: TTreeNode;
  PageCtrl: TModernPageControl; SelectTab: Boolean);
var
  Options: TSynEditorOptions;
begin
  inherited Create(PageCtrl);
  ParentBackground := False;
  FNode := Node;
  FSheetType := SHEET_TYPE_FILE;
  FSynMemo :=  TSynMemo.Create(Self);
  FSynMemo.BorderStyle := bsNone;
  with FrmFalconMain.Config.Editor do
  begin
    Options := FSynMemo.Options;
    //------------ General --------------------------//
    if AutoIndent then Include(Options, eoAutoIndent)
    else Exclude(Options, eoAutoIndent);
    //find text at cursor
    FSynMemo.InsertMode := InsertMode;
    if GroupUndo then Include(Options, eoGroupUndo)
    else Exclude(Options, eoGroupUndo);
    //remove file on close
    if KeepTrailingSpaces then Exclude(Options, eoTabIndent)
    else Include(Options, eoTrimTrailingSpaces);

    if ScrollHint then Exclude(Options, eoShowScrollHint)
    else Include(Options, eoShowScrollHint);
    if TabIndentUnindent then Include(Options, eoTabIndent)
    else Exclude(Options, eoTabIndent);
    if SmartTabs then Include(Options, eoSmartTabs)
    else Exclude(Options, eoSmartTabs);
    if SmartTabs then Include(Options, eoSmartTabs)
    else Exclude(Options, eoSmartTabs);
    if UseTabChar then Exclude(Options, eoTabsToSpaces)
    else Include(Options, eoTabsToSpaces);
    if EnhancedHomeKey then Include(Options, eoEnhanceHomeKey)
    else Exclude(Options, eoEnhanceHomeKey);
    if ShowLineChars then Include(Options, eoShowSpecialChars)
    else Exclude(Options, eoShowSpecialChars);

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

procedure TFilePropertySheet.TextEditorMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  P: TBufferCoord;
begin
  if(Button = mbMiddle) then
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

destructor TFilePropertySheet.Destroy;
begin
  FSynMemo.Free;
  inherited Destroy;
end;

function TFilePropertySheet.GetNode: TTreeNode;
begin
  Result := TTreeNode(FNode)
end;

end.
