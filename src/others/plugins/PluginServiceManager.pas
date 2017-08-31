unit PluginServiceManager;

interface

uses
  Windows, Plugin, Forms, SpTBXItem, Classes, Controls, PluginWidget;

type
  TPluginServiceManager = class
  private
    FForm: TForm;
    FDispatchHandle: HWND;
    FWidgets: TWidgetList;
    function GetHandleFromID(WidgetID: Integer): HWND;
    function GetControlFromID(WidgetID: Integer): TWinControl;

    function CreateMsgBoxWidget(Param: Integer; Data: Pointer): Integer;

    function CreateFormWidget(Plugin: TPlugin; Param: Integer;
      Data: Pointer): Integer;
    function CreateButtonWidget(Plugin: TPlugin; Param: Integer;
      Data: Pointer): Integer;
    function CreateCheckBoxWidget(Plugin: TPlugin; Param: Integer;
      Data: Pointer): Integer;
    function CreateEditWidget(Plugin: TPlugin; Param: Integer;
      Data: Pointer): Integer;
    function CreateLabelWidget(Plugin: TPlugin; Param: Integer;
      Data: Pointer): Integer;

    function CreateMenuItemWidget(Plugin: TPlugin; Param: Integer;
      Data: Pointer): Integer;
    function GetSubmenuFromID(WidgetID: Integer): TSpTBXSubmenuItem;
    function GetMenuItemFromID(WidgetID: Integer): TSpTBXItem;
    function WidgetShowModal(Widget: TWidget): Integer;
    function GetPopupMenuFromID(WidgetID: Integer): TSpTBXPopupMenu;
    function GetFileSelected(WidgetID, Param: Integer; Data: Pointer): Integer;
    function SetWidgetEnabled(WidgetID: Integer; Enabled: Boolean): Integer;
    function GetActiveFile(WidgetID, Param: Integer; Data: Pointer): Integer;
  public
    constructor Create(MainForm: TForm);
    destructor Destroy; override;
    function DispatcheCommand(Plugin: TPlugin; Command, Widget, Param: Integer;
      Data: Pointer): Integer;
    property DispatchHandle: HWND read FDispatchHandle;
    property Widgets: TWidgetList read FWidgets;
  end;

implementation

uses
  PluginConst, PluginWidgetMap, TB2Item, UTemplates, SysUtils,
  UFrmMain,
  UFrmAbout,
  UFrmNew,
  UFrmProperty,
  UFrmCompOptions,
  UFrmRemove,
  UFrmUpdate,
  UFrmEnvOptions,
  UFrmEditorOptions,
  UFrmFind,
  UFrmGotoLine,
  UFrmGotoFunction,
  UFrmPromptCodeTemplate,
  UFrmCodeTemplates,
  UFrmVisualCppOptions, USourceFile;

{ TPluginServiceManager }

constructor TPluginServiceManager.Create(MainForm: TForm);
begin
  FForm := MainForm;
  FDispatchHandle := FForm.Handle;
  FWidgets := TWidgetList.Create;
end;

destructor TPluginServiceManager.Destroy;
begin
  FWidgets.Clear;
  FWidgets.Free;
  inherited;
end;

function TPluginServiceManager.WidgetShowModal(Widget: TWidget): Integer;
begin
  if (Widget = nil) or (Widget.Component = nil) or not (Widget.Component is TWidgetWindow) then
  begin
    Result := -1;
    Exit;
  end;
  Result := TWidgetWindow(Widget.Component).ShowModal;
end;

function TPluginServiceManager.CreateMenuItemWidget(Plugin: TPlugin;
  Param: Integer; Data: Pointer): Integer;
var
  MenuItem: PFCPMenuItem;
  Submenu: TTBCustomItem;
  Submenuitem: TSpTBXSubmenuItem;
  Item, NewItem: TTBCustomItem;
  I: Integer;
  Widget: TWidget;
begin
  MenuItem := PFCPMenuItem(Data);
  Submenu := nil;
  Submenuitem := GetSubmenuFromID(MenuItem^.SubmenuID);
  if Submenuitem <> nil then
    Submenu := Submenuitem;
  if Submenu = nil then
    Submenu := GetPopupMenuFromID(MenuItem^.SubmenuID).Items;
  if Submenu = nil then
  begin
    Result := 0;
    Exit;
  end;
  if MenuItem^.Position = 0 then
    Item := nil
  else
    Item := GetMenuItemFromID(MenuItem^.Position);
  if Item <> nil then
    I := Submenu.IndexOf(Item)
  else
    I := Submenu.Count;
  Widget := Widgets.Add(Plugin);
  if StrPas(MenuItem^.Text) = '-' then
    NewItem := TWidgetMenuSeparator.CreateWidget(Widget, Submenu.Owner)
  else
    NewItem := TWidgetMenuItem.CreateWidget(Widget, Submenu.Owner);
  NewItem.Tag := Widget.ID;
  NewItem.Caption := string(StrPas(MenuItem^.Text));
  NewItem.ImageIndex := MenuItem^.ImageIndex;
  NewItem.ShortCut := MenuItem^.ShortCut;
  Submenu.Insert(I, NewItem);
  Result := Widget.ID;
end;

function TPluginServiceManager.CreateMsgBoxWidget(Param: Integer;
  Data: Pointer): Integer;
var
  MsgBox: PFCPMsgBox;
begin
  MsgBox := PFCPMsgBox(Data);
  Result := MessageBox(GetHandleFromID(MsgBox^.ParentID), PChar(string(StrPas(MsgBox^.Text))), 
    PChar(string(StrPas(MsgBox^.Title))), MsgBox^.uType);
end;

function TPluginServiceManager.CreateFormWidget(Plugin: TPlugin;
  Param: Integer; Data: Pointer): Integer;
var
  Window: PFCPWindow;
  NativeForm: TWidgetWindow;
  Widget: TWidget;
begin
  Window := PFCPWindow(Data);
  Widget := Widgets.Add(Plugin);
  NativeForm := TWidgetWindow.CreateWidget(Widget, GetHandleFromID(Window^.ParentID));
  case Window^.Border of
    Wb_Dialog: NativeForm.BorderStyle := bsDialog;
    Wb_Single: NativeForm.BorderStyle := bsSingle;
    Wb_ToolWindow: NativeForm.BorderStyle := bsToolWindow;
    Wb_SizeToolWin: NativeForm.BorderStyle := bsSizeToolWin;
    Wb_None: NativeForm.BorderStyle := bsNone;
  end;
  NativeForm.Caption := string(StrPas(Window^.Text));
  NativeForm.ClientWidth := Window^.Width;
  NativeForm.ClientHeight := Window^.Height;
  if (Window^.X = -1) and (Window^.Y = -1) then
    NativeForm.Position := poOwnerFormCenter
  else
  begin
    NativeForm.Left := Window^.X;
    NativeForm.Top := Window^.Y;
  end;
  Result := Widget.ID;
end;

function TPluginServiceManager.CreateButtonWidget(Plugin: TPlugin;
  Param: Integer; Data: Pointer): Integer;
var
  Button: PFCPButton;
  WidgetButton: TWidgetButton;
  Widget: TWidget;
  Control: TWinControl;
begin
  Button := PFCPButton(Data);
  Control := GetControlFromID(Button^.ParentID);
  if Control = nil then
  begin
    Result := 0;
    Exit;
  end;
  Widget := Widgets.Add(Plugin);
  WidgetButton := TWidgetButton.CreateWidget(Widget, Control);
  WidgetButton.Parent := Control;
  WidgetButton.Caption := string(StrPas(Button^.Text));
  WidgetButton.Width := Button^.Width;
  WidgetButton.Height := Button^.Height;
  WidgetButton.Left := Button^.X;
  WidgetButton.Top := Button^.Y;
  Result := Widget.ID;
end;

function TPluginServiceManager.CreateCheckBoxWidget(Plugin: TPlugin;
  Param: Integer; Data: Pointer): Integer;
var
  CheckBox: PFCPCheckBox;
  WidgetCheckBox: TWidgetCheckBox;
  Widget: TWidget;
  Control: TWinControl;
begin
  CheckBox := PFCPCheckBox(Data);
  Control := GetControlFromID(CheckBox^.ParentID);
  if Control = nil then
  begin
    Result := 0;
    Exit;
  end;
  Widget := Widgets.Add(Plugin);
  WidgetCheckBox := TWidgetCheckBox.CreateWidget(Widget, Control);
  WidgetCheckBox.Parent := Control;
  WidgetCheckBox.Caption := string(StrPas(CheckBox^.Text));
  WidgetCheckBox.Width := CheckBox^.Width;
  WidgetCheckBox.Height := CheckBox^.Height;
  WidgetCheckBox.Left := CheckBox^.X;
  WidgetCheckBox.Top := CheckBox^.Y;
  Result := Widget.ID;
end;

function TPluginServiceManager.CreateEditWidget(Plugin: TPlugin;
  Param: Integer; Data: Pointer): Integer;
var
  Edit: PFCPEdit;
  WidgetEdit: TWidgetEdit;
  Widget: TWidget;
  Control: TWinControl;
begin
  Edit := PFCPEdit(Data);
  Control := GetControlFromID(Edit^.ParentID);
  if Control = nil then
  begin
    Result := 0;
    Exit;
  end;
  Widget := Widgets.Add(Plugin);
  WidgetEdit := TWidgetEdit.CreateWidget(Widget, Control);
  WidgetEdit.Parent := Control;
  WidgetEdit.Width := Edit^.Width;
  WidgetEdit.Height := Edit^.Height;
  WidgetEdit.Left := Edit^.X;
  WidgetEdit.Top := Edit^.Y;
  Result := Widget.ID;
end;

function TPluginServiceManager.CreateLabelWidget(Plugin: TPlugin;
  Param: Integer; Data: Pointer): Integer;
var
  aLabel: PFCPLabel;
  WidgetLabel: TWidgetLabel;
  Widget: TWidget;
  Control: TWinControl;
begin
  aLabel := PFCPLabel(Data);
  Control := GetControlFromID(aLabel^.ParentID);
  if Control = nil then
  begin
    Result := 0;
    Exit;
  end;
  Widget := Widgets.Add(Plugin);
  WidgetLabel := TWidgetLabel.CreateWidget(Widget, Control);
  WidgetLabel.Parent := Control;
  WidgetLabel.Caption := string(StrPas(aLabel^.Text));
  WidgetLabel.Width := aLabel^.Width;
  WidgetLabel.Height := aLabel^.Height;
  WidgetLabel.Left := aLabel^.X;
  WidgetLabel.Top := aLabel^.Y;
  Result := Widget.ID;
end;

function TPluginServiceManager.GetFileSelected(WidgetID, Param: Integer; 
  Data: Pointer): Integer;
var
  MainForm: TFrmFalconMain;
  SelectedFile: TSourceBase;
  SourceFile: PFCPSourceFile;
  S: AnsiString;
begin           
  MainForm := TFrmFalconMain(FForm);
  if WidgetID = TREEVIEW_PROJECTS then
  begin
    if MainForm.TreeViewProjects.SelectionCount = 1 then
    begin
      SelectedFile := TSourceFile(MainForm.TreeViewProjects.Selected.Data);
      SourceFile := PFCPSourceFile(Data);
      SourceFile^.uType := SelectedFile.FileType;
      SourceFile^.Flags := 0;
      if SelectedFile.Modified then
        SourceFile^.Flags := SourceFile^.Flags + Sf_Modified;
      if SelectedFile.Saved then
        SourceFile^.Flags := SourceFile^.Flags + Sf_Saved;
      if SelectedFile.Node.Selected then
        SourceFile^.Flags := SourceFile^.Flags + Sf_Selected;
      if SelectedFile is TProjectBase then
        SourceFile^.Flags := SourceFile^.Flags + Sf_Project;
      S := AnsiString(SelectedFile.FileName);
      CopyMemory(@SourceFile^.FileName, Pointer(S), Length(S) + 1);
      Result := 0;
      Exit;
    end;
  end;
  Result := 1;
end;

function TPluginServiceManager.GetActiveFile(WidgetID, Param: Integer; 
  Data: Pointer): Integer;
var
  MainForm: TFrmFalconMain;
  ActiveFile: TSourceBase;
  SourceFile: PFCPSourceFile;
  S: AnsiString;
begin
  MainForm := TFrmFalconMain(FForm);
  if MainForm.GetActiveSource(ActiveFile) then
  begin
    SourceFile := PFCPSourceFile(Data);
    SourceFile^.uType := ActiveFile.FileType;
    SourceFile^.Flags := 0;
    if ActiveFile.Modified then
      SourceFile^.Flags := SourceFile^.Flags + Sf_Modified;
    if ActiveFile.Saved then
      SourceFile^.Flags := SourceFile^.Flags + Sf_Saved;
    if ActiveFile.Node.Selected then
      SourceFile^.Flags := SourceFile^.Flags + Sf_Selected;
    if ActiveFile is TProjectBase then
      SourceFile^.Flags := SourceFile^.Flags + Sf_Project;
    S := AnsiString(ActiveFile.FileName);
    CopyMemory(@SourceFile^.FileName, Pointer(S), Length(S) + 1);
    Result := 0;
    Exit;
  end;
  Result := 1;
end;

function TPluginServiceManager.DispatcheCommand(Plugin: TPlugin; Command,
  Widget, Param: Integer; Data: Pointer): Integer;
begin
  case Command of
    Cmd_Free:
    begin
      if Widget = Plugin.ID then
      begin
        Widgets.ClearForPluginID(Plugin.ID);
        TFrmFalconMain(FForm).PluginManager.Delete(Plugin.ID);
      end
      else
      begin
        Result := Widgets.Delete(Widget);
        Exit;
      end;
    end;
    Cmd_Create:
    begin
      case Widget of
        Wdg_MsgBox:
          Result := CreateMsgBoxWidget(Param, Data);
        Wdg_MenuItem:
          Result := CreateMenuItemWidget(Plugin, Param, Data);
        Wdg_Window:
          Result := CreateFormWidget(Plugin, Param, Data);
        Wdg_Button:
          Result := CreateButtonWidget(Plugin, Param, Data);
        Wdg_CheckBox:
          Result := CreateCheckBoxWidget(Plugin, Param, Data);
        Wdg_Edit:
          Result := CreateEditWidget(Plugin, Param, Data);
        Wdg_Label:
          Result := CreateLabelWidget(Plugin, Param, Data);
      else
        Result := 0;
      end;
      Exit;
    end;
    Cmd_ShowModal:
    begin
      Result := WidgetShowModal(Widgets.Find(Widget));
      Exit;
    end;
    Cmd_ActiveFile:
    begin
      Result := GetActiveFile(Widget, Param, Data);
      Exit;
    end;
    Cmd_FileSelected:
    begin
      Result := GetFileSelected(Widget, Param, Data);
      Exit;
    end;
    Cmd_Enabled:
    begin
      Result := SetWidgetEnabled(Widget, Param <> 0);
      Exit;
    end
  else
  end;
  Result := 0;
end;

function TPluginServiceManager.SetWidgetEnabled(WidgetID: Integer; 
  Enabled: Boolean): Integer;
var
  Component: TComponent;
begin
  Component := GetMenuItemFromID(WidgetID);
  if Component <> nil then
  begin
    TSpTBXItem(Component).Enabled := Enabled;
    Result := 0; 
    Exit;
  end;
  Result := 1;
end;

function TPluginServiceManager.GetHandleFromID(WidgetID: Integer): HWND;
var
  Control: TWinControl;
begin
  Control := GetControlFromID(WidgetID);
  if Control <> nil then
    Result := Control.Handle
  else
    Result := 0;
end;

function TPluginServiceManager.GetSubmenuFromID(WidgetID: Integer): TSpTBXSubmenuItem;
var
  MainForm: TFrmFalconMain;
  Widget: TWidget;
begin
  MainForm := TFrmFalconMain(FForm);
  if WidgetID > $00FFFF then
  begin
    Widget := Widgets.Find(WidgetID);
    if (Widget <> nil) and (Widget.Component is TSpTBXSubmenuItem) then
      Result := TSpTBXSubmenuItem(Widget.Component)
    else
      Result := nil;
    Exit;
  end;
  case WidgetID of
    SUBMENU_MAIN_FILE: Result := MainForm.MenuFile;
    SUBMENU_MAIN_FILE_NEW: Result := MainForm.FileNew;
    SUBMENU_MAIN_FILE_REOPEN: Result := MainForm.FileReopen;
    SUBMENU_MAIN_FILE_IMPORT: Result := MainForm.FileImport;
    SUBMENU_MAIN_FILE_EXPORT: Result := MainForm.FileExport;
    SUBMENU_MAIN_EDIT: Result := MainForm.MenuEdit;
    SUBMENU_MAIN_EDIT_TOGGLEBOOKMARKS: Result := MainForm.EditBookmarks;
    SUBMENU_MAIN_EDIT_GOTOBOOKMARKS: Result := MainForm.EditGotoBookmarks;
    SUBMENU_MAIN_SEARCH: Result := MainForm.MenuSearch;
    SUBMENU_MAIN_VIEW: Result := MainForm.MenuView;
    SUBMENU_MAIN_VIEW_TOOLBARS: Result := MainForm.ViewToolbar;
    SUBMENU_MAIN_VIEW_THEMES: Result := MainForm.ViewThemes;
    SUBMENU_MAIN_VIEW_ZOOM: Result := MainForm.ViewZoom;
    SUBMENU_MAIN_PROJECT: Result := MainForm.MenuProject;
    SUBMENU_MAIN_RUN: Result := MainForm.MenuRun;
    SUBMENU_MAIN_TOOLS: Result := MainForm.MenuTools;
    SUBMENU_MAIN_HELP: Result := MainForm.MenuHelp;
    SUBMENU_MAIN_HELP_FALCONCPP: Result := MainForm.HelpFalcon;

    SUBMENU_PROJECT_NEW: Result := MainForm.PopProjNew;
  else
    Result := nil;
  end;
end;

function TPluginServiceManager.GetPopupMenuFromID(WidgetID: Integer): TSpTBXPopupMenu;
var
  MainForm: TFrmFalconMain;
  Widget: TWidget;
begin
  MainForm := TFrmFalconMain(FForm);
  if WidgetID > $00FFFF then
  begin
    Widget := Widgets.Find(WidgetID);
    if (Widget <> nil) and (Widget.Component is TSpTBXPopupMenu) then
      Result := TSpTBXPopupMenu(Widget.Component)
    else
      Result := nil;
    Exit;
  end;
  case WidgetID of
    POPUPMENU_PROJECT: Result:= MainForm.PopupProject;
  else
    Result := nil;
  end;
end;

function TPluginServiceManager.GetMenuItemFromID(WidgetID: Integer): TSpTBXItem;
var
  MainForm: TFrmFalconMain;
  Widget: TWidget;
begin
  MainForm := TFrmFalconMain(FForm);
  if WidgetID > $00FFFF then
  begin
    Widget := Widgets.Find(WidgetID);
    if Widget <> nil then
      Result := TSpTBXItem(Widget.Component)
    else
      Result := nil;
    Exit;
  end;
  case WidgetID of
    MENUITEM_MAIN_FILE_NEW_PROJECT: Result := MainForm.FileNewProject;
    MENUITEM_MAIN_FILE_NEW_CFILE: Result := MainForm.FileNewC;
    MENUITEM_MAIN_FILE_NEW_CPPFILE: Result := MainForm.FileNewCpp;
    MENUITEM_MAIN_FILE_NEW_HEADER: Result := MainForm.FileNewHeader;
    MENUITEM_MAIN_FILE_NEW_RESOURCE: Result := MainForm.FileNewResource;
    MENUITEM_MAIN_FILE_NEW_EMPTY: Result := MainForm.FileNewEmpty;
    MENUITEM_MAIN_FILE_NEW_FOLDER: Result := MainForm.FileNewFolder;
    MENUITEM_MAIN_FILE_OPEN: Result := MainForm.FileOpen;
    MENUITEM_MAIN_FILE_REOPEN_CLEAR: Result := MainForm.FileReopenClear;
    MENUITEM_MAIN_FILE_SAVE: Result := MainForm.FileSave;
    MENUITEM_MAIN_FILE_SAVEAS: Result := MainForm.FileSaveAs;
    MENUITEM_MAIN_FILE_SAVEALL: Result := MainForm.FileSaveAll;
    MENUITEM_MAIN_FILE_IMPORT_DEVCPP: Result := MainForm.FileImpDevCpp;
    MENUITEM_MAIN_FILE_IMPORT_CODEBLOCKS: Result := MainForm.FileImpCodeBlocks;
    MENUITEM_MAIN_FILE_IMPORT_MSVISUALCPP: Result := MainForm.FileImpMSVC;
    MENUITEM_MAIN_FILE_EXPORT_HTML: Result := MainForm.FileExportHTML;
    MENUITEM_MAIN_FILE_EXPORT_RTF: Result := MainForm.FileExportRTF;
    MENUITEM_MAIN_FILE_EXPORT_TEX: Result := MainForm.FileExportTeX;
    MENUITEM_MAIN_FILE_CLOSE: Result := MainForm.FileClose;
    MENUITEM_MAIN_FILE_CLOSEALL: Result := MainForm.FileCloseAll;
    MENUITEM_MAIN_FILE_REMOVE: Result := MainForm.FileRemove;
    MENUITEM_MAIN_FILE_PRINT: Result := MainForm.FilePrint;
    MENUITEM_MAIN_FILE_EXIT: Result := MainForm.FileExit;
    MENUITEM_MAIN_EDIT_UNDO: Result := MainForm.EditUndo;
    MENUITEM_MAIN_EDIT_REDO: Result := MainForm.EditRedo;
    MENUITEM_MAIN_EDIT_CUT: Result := MainForm.EditCut;
    MENUITEM_MAIN_EDIT_COPY: Result := MainForm.EditCopy;
    MENUITEM_MAIN_EDIT_PASTE: Result := MainForm.EditPaste;
    MENUITEM_MAIN_EDIT_SWAPHS: Result := MainForm.EditSwap;
    MENUITEM_MAIN_EDIT_DELETE: Result := MainForm.EditDelete;
    MENUITEM_MAIN_EDIT_SELECTALL: Result := MainForm.EditSelectAll;
    MENUITEM_MAIN_EDIT_INDENT: Result := MainForm.EditIndent;
    MENUITEM_MAIN_EDIT_UNINDENT: Result := MainForm.EditUnindent;
    MENUITEM_MAIN_EDIT_TOGGLECOMMENT: Result := MainForm.EditToggleComment;
    MENUITEM_MAIN_SEARCH_FIND: Result := MainForm.SearchFind;
    MENUITEM_MAIN_SEARCH_FINDNEXT: Result := MainForm.SearchFindNext;
    MENUITEM_MAIN_SEARCH_FINDPREV: Result := MainForm.SearchFindPrev;
    MENUITEM_MAIN_SEARCH_FINDFILES: Result := MainForm.SearchFindFiles;
    MENUITEM_MAIN_SEARCH_REPLACE: Result := MainForm.SearchReplace;
    MENUITEM_MAIN_SEARCH_INCSEARCH: Result := MainForm.SearchIncremental;
    MENUITEM_MAIN_SEARCH_GOTOFUNC: Result := MainForm.SearchGotoFunction;
    MENUITEM_MAIN_SEARCH_GOTOPREVFUNC: Result := MainForm.SearchGotoPrevFunc;
    MENUITEM_MAIN_SEARCH_GOTONEXTFUNC: Result := MainForm.SearchGotoNextFunc;
    MENUITEM_MAIN_SEARCH_GOTOLINE: Result := MainForm.SearchGotoLine;
    MENUITEM_MAIN_VIEW_PROJECTMANAGER: Result := MainForm.ViewProjMan;
    MENUITEM_MAIN_VIEW_STATUSBAR: Result := MainForm.ViewStatusBar;
    MENUITEM_MAIN_VIEW_OUTLINE: Result := MainForm.ViewOutline;
    MENUITEM_MAIN_VIEW_COMPILEROUTPUT: Result := MainForm.ViewCompOut;
    //MENUITEM_MAIN_VIEW_TOOLBARS_DEFAULT: Result := MainForm.ViewThemeDef;
    MENUITEM_MAIN_VIEW_TOOLBARS_EDIT: Result := MainForm.ViewToolbarEdit;
    MENUITEM_MAIN_VIEW_TOOLBARS_SEARCH: Result := MainForm.ViewToolbarSearch;
    MENUITEM_MAIN_VIEW_TOOLBARS_COMPILER: Result := MainForm.ViewToolbarCompiler;
    MENUITEM_MAIN_VIEW_TOOLBARS_NAVIGATOR: Result := MainForm.ViewToolbarNavigator;
    MENUITEM_MAIN_VIEW_TOOLBARS_PROJECT: Result := MainForm.ViewToolbarProject;
    MENUITEM_MAIN_VIEW_TOOLBARS_HELP: Result := MainForm.ViewToolbarHelp;
    MENUITEM_MAIN_VIEW_TOOLBARS_DEBUG: Result := MainForm.ViewToolbarDebug;
    //MENUITEM_MAIN_VIEW_THEMES_DEFAULT: Result := MainForm.ViewThemeDef;
    //MENUITEM_MAIN_VIEW_THEMES_OFFICE2003: Result := MainForm.ViewThemeOffice2003;
    //MENUITEM_MAIN_VIEW_THEMES_OFFICEXP: Result := MainForm.ViewThemeOffXP;
   // MENUITEM_MAIN_VIEW_THEMES_STRIPES: Result := MainForm.ViewThemeStripes;
    //MENUITEM_MAIN_VIEW_THEMES_PROFESSIONAL: Result := MainForm.ViewThemeProfessional;
    //MENUITEM_MAIN_VIEW_THEMES_ALUMINUM: Result := MainForm.ViewThemeAluminum;
    MENUITEM_MAIN_VIEW_ZOOM_INCREASE: Result := MainForm.ViewZoomInc;
    MENUITEM_MAIN_VIEW_ZOOM_DECREASE: Result := MainForm.ViewZoomDec;
    MENUITEM_MAIN_VIEW_FULLSCREEN: Result := MainForm.ViewFullScreen;
    MENUITEM_MAIN_VIEW_RESTOREDEFAULT: Result := MainForm.ViewRestoreDefault;
    MENUITEM_MAIN_PROJECT_ADD: Result := MainForm.ProjectAdd;
    MENUITEM_MAIN_PROJECT_REMOVE: Result := MainForm.ProjectRemove;
    MENUITEM_MAIN_PROJECT_BUILD: Result := MainForm.ProjectBuild;
    MENUITEM_MAIN_PROJECT_PROPERTY: Result := MainForm.ProjectProperties;
    MENUITEM_MAIN_RUN_RUN: Result := MainForm.RunRun;
    MENUITEM_MAIN_RUN_COMPILE: Result := MainForm.RunCompile;
    MENUITEM_MAIN_RUN_EXECUTE: Result := MainForm.RunExecute;
    MENUITEM_MAIN_RUN_TOGGLEBREAKPOINT: Result := MainForm.RunToggleBreakpoint;
    MENUITEM_MAIN_RUN_STEPINTO: Result := MainForm.RunStepInto;
    MENUITEM_MAIN_RUN_STEPOVER: Result := MainForm.RunStepOver;
    MENUITEM_MAIN_RUN_RUNTOCURSOR: Result := MainForm.RunRuntoCursor;
    MENUITEM_MAIN_RUN_STOP: Result := MainForm.RunStop;
    MENUITEM_MAIN_TOOLS_ENVIRONMENTOPTIONS: Result := MainForm.ToolsEnvOptions;
    MENUITEM_MAIN_TOOLS_COMPILEROPTIONS: Result := MainForm.ToolsCompilerOptions;
    MENUITEM_MAIN_TOOLS_EDITOROPTIONS: Result := MainForm.ToolsEditorOptions;
    MENUITEM_MAIN_TOOLS_TEMPLATECREATOR: Result := MainForm.ToolsTemplate;
    MENUITEM_MAIN_TOOLS_PACKAGECREATOR: Result := MainForm.ToolsPackageCreator;
    MENUITEM_MAIN_TOOLS_PACKAGES: Result := MainForm.ToolsPackages;
    MENUITEM_MAIN_HELP_FALCONCPP_FALCONCPP: Result := MainForm.HelpFalconFalcon;
    MENUITEM_MAIN_HELP_TIPOFDAY: Result := MainForm.HelpTipOfDay;
    MENUITEM_MAIN_HELP_UPDATE: Result := MainForm.HelpUpdate;
    MENUITEM_MAIN_HELP_ABOUT: Result := MainForm.HelpAbout;

    MENUITEM_PROJECT_EDIT: Result := MainForm.PopProjEdit;
    MENUITEM_PROJECT_OPEN: Result := MainForm.PopProjOpen;
    MENUITEM_PROJECT_ADDTOPROJECT: Result := MainForm.PopProjAdd;
    MENUITEM_PROJECT_REMOVE: Result := MainForm.PopProjRemove;
    MENUITEM_PROJECT_RENAME: Result := MainForm.PopProjRename;
    MENUITEM_PROJECT_DELETEFROMDISK: Result := MainForm.PopProjDelFromDsk;
    MENUITEM_PROJECT_PROPERTY: Result := MainForm.PopProjProp;
  else
    if (WidgetID >= MENUITEM_MAIN_EDIT_TOGGLEBOOKMARKS_1) and
       (WidgetID <= MENUITEM_MAIN_EDIT_TOGGLEBOOKMARKS_9) and
       (WidgetID - MENUITEM_MAIN_EDIT_TOGGLEBOOKMARKS_1 < MainForm.EditBookmarks.Count) then
    begin
      Result := TSpTBXItem(MainForm.EditBookmarks.Items[WidgetID - MENUITEM_MAIN_EDIT_TOGGLEBOOKMARKS_1])
    end
    else if (WidgetID >= MENUITEM_MAIN_EDIT_GOTOBOOKMARKS_1) and
       (WidgetID <= MENUITEM_MAIN_EDIT_GOTOBOOKMARKS_9) and
       (WidgetID - MENUITEM_MAIN_EDIT_GOTOBOOKMARKS_1 < MainForm.EditGotoBookmarks.Count) then
    begin
      Result := TSpTBXItem(MainForm.EditGotoBookmarks.Items[WidgetID - MENUITEM_MAIN_EDIT_GOTOBOOKMARKS_1])
    end
    else
      Result := nil;
  end;
end;

function TPluginServiceManager.GetControlFromID(WidgetID: Integer): TWinControl;
var
  MainForm: TFrmFalconMain;
  Widget: TWidget;
begin
  MainForm := TFrmFalconMain(FForm);
  Result := nil;
  if WidgetID > $00FFFF then
  begin
    Widget := Widgets.Find(WidgetID);
    if (Widget <> nil) and (Widget.Component is TWinControl) then
      Result := TWinControl(Widget.Component);
    Exit;
  end;
  case WidgetID of
    WINDOW_MAIN: Result := MainForm;
    WINDOW_COMPILER_OPTIONS: Result := FrmCompOptions;
    WINDOW_EDITOR_OPTIONS: Result := FrmEditorOptions;
    WINDOW_ENVIRONMENT_OPTIONS: Result := FrmEnvOptions;
    WINDOW_FIND: Result := FrmFind;
    WINDOW_NEW_PROJECT: Result := FrmNewProj;
    WINDOW_PROJECT_PROPERTY: Result := FrmProperty;
    WINDOW_PROJECT_REMOVE: Result := FrmRemove;
    WINDOW_UPDATE: Result := FrmUpdate;
    WINDOW_GOTO_LINE: Result := FormGotoLine;
    WINDOW_GOTO_FUNCTION: Result := FormGotoFunction;
    WINDOW_ABOUT: Result := FormAbout;
  end;
end;

end.
