unit PluginConst;

interface

const
  {* Commands *}
	Cmd_Create             = $0001;
	Cmd_Free               = $0002;
	Cmd_Destroy            = $0003;
	Cmd_Get                = $0004;
	Cmd_Set                = $0005;
	Cmd_CompilerChanged    = $0006;
	Cmd_LangChanged        = $0007;
	Cmd_TabClosing         = $0008;
	Cmd_TabClosed          = $0009;
	Cmd_Select             = $000A;
	Cmd_Click              = $000B;
	Cmd_MouseDown          = $000C;
	Cmd_MouseUp            = $000D;
	Cmd_MouseMove          = $000E;
	Cmd_KeyDown            = $000C;
	Cmd_KeyUp              = $000D;
	Cmd_KeyPress           = $000E;
	Cmd_FileSelected       = $000F;
	Cmd_FileDeleted        = $0010;
	Cmd_PosChanged         = $0011;
	Cmd_SizeChanged        = $0012;
	Cmd_ScreenModeChanged  = $0013;
	Cmd_Show               = $0014;
	Cmd_Hide               = $0015;
  Cmd_ShowModal          = $0016;

  {* Properties *}
  Prop_Text            = $0001;
  Prop_Size            = $0002;
  Prop_Info            = $0003; // Plugin info
  Prop_Name            = $0004;

  {* Events *}
	Event_Click        = $AAAB;
	Event_DblClick     = $AAAC;
	Event_Change       = $AAAD;
	Event_MouseDown    = $AAAE;
	Event_MouseUp      = $AAAF;
	Event_MouseMove    = $AAB0;
	Event_KeyDown      = $AAB1;
	Event_KeyUp        = $AAB2;
	Event_KeyPress     = $AAB3;
	Event_Close        = $AAB4;
	Event_PageChange   = $AAB5;
	Event_Resize       = $AAB6;

  {* Widgets *}
	Wdg_Menu             = $0001;
	Wdg_PopupMenu        = $0002;
	Wdg_SubMenu          = $0003;
	Wdg_MenuItem         = $0004;
	Wdg_PageControl      = $0005;
	Wdg_Sheet            = $0006;
	Wdg_Edit             = $0007;
	Wdg_Button           = $0008;
	Wdg_CheckBox         = $0009;
	Wdg_GroupBox         = $000A;
	Wdg_RadioGroup       = $000B;
	Wdg_List             = $000C;
	Wdg_ListView         = $000D;
	Wdg_TreeView         = $000E;
	Wdg_ModerPageControl = $000F;
	Wdg_ModerSheet       = $0010;
	Wdg_Panel            = $0011;
	Wdg_Shape            = $0012;
	Wdg_Window           = $0013;
	Wdg_MsgBox           = $0014;
	Wdg_Plugin           = $FFFF;

  {* WindowBorder *}
  Wb_Sizeable    = $0000;
  Wb_Dialog      = $0001;
  Wb_Single      = $0002;
  Wb_ToolWindow  = $0003;
  Wb_SizeToolWin = $0004;
  Wb_None        = $0005;


  cannotLoadPlugin = 'Can''t load plugin %s.';
  functionNotFound = 'Function %s not found.';
  invalidPlugin = 'Invalid plugin.';
  failedToInitializePlugin = 'Failed to initialize plugin: error code %d.';
  pluginNotInitialized = 'Plugin not initialized.';


// REGEX C TO PASCAL
// FIND: typedef struct [^{]+\{([^}]+)\} ([^\;]+)
// REPLACE: T$2 = record$1end\nP$2 = \^T$2

type
  TDispatchCommand = record
    Command: Integer;
    Widget: Integer;
    Param: Integer;
    Data: Pointer;
  end;
  PDispatchCommand = ^TDispatchCommand;

  TWindow = record
    ParentID: Integer;
    X: Integer;
    Y: Integer;
    Width: Integer;
    Height: Integer;
    Text: PChar;
    Border: Integer;
  end;
  PWindow = ^TWindow;

  TButton = record
    ParentID: Integer;
    X: Integer;
    Y: Integer;
    Width: Integer;
    Height: Integer;
    Text: PChar;
  end;
  PButton = ^TButton;

  TMenu = record
    ParentID: Integer;
    ImageList: Integer;
  end;
  PMenu = ^TMenu;

  TMenuItem = record
    SubmenuID: Integer;
    ImageIndex: Integer;
    Position: Integer;
    Text: PChar;
    ShortCut: Word;
  end;
  PMenuItem = ^TMenuItem;

  TMsgBox = record
    ParentID: Integer;
    Text: PChar;
    Title: PChar;
    uType: Cardinal;
  end;
  PMsgBox = ^TMsgBox;

implementation

end.
