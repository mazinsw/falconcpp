unit PluginConst;

interface

const
  {* Commands *}
	Cmd_Create             = $0001;
	Cmd_Free               = $0002;
	Cmd_Destroy            = $0003;
	Cmd_Get                = $0004;
	Cmd_Set                = $0005;
	Cmd_Select             = $0006;
	Cmd_Click              = $0007;
	Cmd_MouseDown          = $0008;
	Cmd_MouseMove          = $0009;
	Cmd_MouseUp            = $000A;
	Cmd_KeyDown            = $000B;
	Cmd_KeyUp              = $000C;
	Cmd_KeyPress           = $000D;
	Cmd_Resize             = $000E;
	Cmd_Show               = $000F;
	Cmd_Hide               = $0010;
	Cmd_ShowModal          = $0011;
	Cmd_DblClick           = $0012;
	Cmd_Change             = $0013;
	Cmd_Close              = $0014;
	Cmd_PageChange         = $0015;
	Cmd_Enter              = $0016;
	Cmd_Exit               = $0017;
  Cmd_Popup              = $0018;
	Cmd_Enabled            = $0019;
	
	Cmd_CompilerChanged    = $0100;
	Cmd_LangChanged        = $0101;
	Cmd_FileSelected       = $0102;
	Cmd_FileDeleted        = $0103;
	Cmd_ScreenModeChanged  = $0104;
	Cmd_ActiveFile         = $0105;

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
	Event_Popup        = $AAD7;

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
	Wdg_ListBox          = $000C;
	Wdg_ListView         = $000D;
	Wdg_TreeView         = $000E;
	Wdg_ModerPageControl = $000F;
	Wdg_ModerSheet       = $0010;
	Wdg_Panel            = $0011;
	Wdg_Shape            = $0012;
	Wdg_Window           = $0013;
	Wdg_MsgBox           = $0014;
	Wdg_RadioButton      = $0015;
	Wdg_ComboBox         = $0016;
	Wdg_Label            = $0017;
	Wdg_Memo             = $0018;

  {* WindowBorder *}
  Wb_Sizeable    = $0000;
  Wb_Dialog      = $0001;
  Wb_Single      = $0002;
  Wb_ToolWindow  = $0003;
  Wb_SizeToolWin = $0004;
  Wb_None        = $0005;


  {* CloseAction *}
  Ca_None     = $00;
	Ca_Hide     = $01;
	Ca_Free     = $02;
	Ca_Minimize = $03;

  {* SourceFileFlags *}
  Sf_Modified = $01;
  Sf_Saved    = $02;
  Sf_Selected = $04;
  Sf_Project  = $08;


  cannotLoadPlugin = 'Can''t load plugin %s.';
  functionNotFound = 'Function %s not found.';
  invalidPlugin = 'Invalid plugin.';
  failedToInitializePlugin = 'Failed to initialize plugin: error code %d.';
  pluginNotInitialized = 'Plugin not initialized.';
  pluginAlreadyExists  = 'Plugin with ID: %d already exists.';
  pluginIncompatibleVersion = 'Failed to initialize plugin: incompatible plugin ' +
    'version %s with plugin manager version %s.';


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

  TFCPWindow = record
    ParentID: Integer;
    X: Integer;
    Y: Integer;
    Width: Integer;
    Height: Integer;
    Text: PAnsiChar;
    Border: Integer;
  end;
  PFCPWindow = ^TFCPWindow;

  TFCPButton = record
    ParentID: Integer;
    X: Integer;
    Y: Integer;
    Width: Integer;
    Height: Integer;
    Text: PAnsiChar;
  end;
  PFCPButton = ^TFCPButton;

  TFCPCheckBox = record
    ParentID: Integer;
    X: Integer;
    Y: Integer;
    Width: Integer;
    Height: Integer;
    Text: PAnsiChar;
  end;
  PFCPCheckBox = ^TFCPCheckBox;

  TFCPEdit = record
    ParentID: Integer;
    X: Integer;
    Y: Integer;
    Width: Integer;
    Height: Integer;
  end;
  PFCPEdit = ^TFCPEdit;

  TFCPLabel = record
    ParentID: Integer;
    X: Integer;
    Y: Integer;
    Width: Integer;
    Height: Integer;
    Text: PAnsiChar;
  end;
  PFCPLabel = ^TFCPLabel;

  TFCPMenu = record
    ParentID: Integer;
    ImageList: Integer;
  end;
  PFCPMenu = ^TFCPMenu;

  TFCPMenuItem = record
    SubmenuID: Integer;
    ImageIndex: Integer;
    Position: Integer;
    Text: PAnsiChar;
    ShortCut: Word;
  end;
  PFCPMenuItem = ^TFCPMenuItem;

  TFCPMsgBox = record
    ParentID: Integer;
    Text: PAnsiChar;
    Title: PAnsiChar;
    uType: Cardinal;
  end;
  PFCPMsgBox = ^TFCPMsgBox;

  TFCPSourceFile = record
    FileName: array[0..259] of AnsiChar;
    Flags: Cardinal;
    uType: Integer;
  end;
  PFCPSourceFile = ^TFCPSourceFile;

implementation

end.
