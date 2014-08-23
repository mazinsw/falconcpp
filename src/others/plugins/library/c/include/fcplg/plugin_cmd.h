#ifndef _PLUGIN_CMD_H_
#define _PLUGIN_CMD_H_

/* Commands */
enum Commands
{
	Cmd_Create             = 0x0001,
	Cmd_Free               = 0x0002,
	Cmd_Destroy            = 0x0003,
	Cmd_Get                = 0x0004,
	Cmd_Set                = 0x0005,
	Cmd_Select             = 0x0006,
	Cmd_Click              = 0x0007,
	Cmd_MouseDown          = 0x0008,
	Cmd_MouseMove          = 0x0009,
	Cmd_MouseUp            = 0x000A,
	Cmd_KeyDown            = 0x000B,
	Cmd_KeyUp              = 0x000C,
	Cmd_KeyPress           = 0x000D,
	Cmd_Resize             = 0x000E,
	Cmd_Show               = 0x000F,
	Cmd_Hide               = 0x0010,
	Cmd_ShowModal          = 0x0011,
	Cmd_DblClick           = 0x0012,
	Cmd_Change             = 0x0013,
	Cmd_Close              = 0x0014,
	Cmd_PageChange         = 0x0015,
	Cmd_Enter              = 0x0016,
	Cmd_Exit               = 0x0017,
	Cmd_Popup              = 0x0018,
	Cmd_Enabled            = 0x0019,

	Cmd_CompilerChanged    = 0x0100,
	Cmd_LangChanged        = 0x0101,
	Cmd_FileSelected       = 0x0102,
	Cmd_FileDeleted        = 0x0103,
	Cmd_ScreenModeChanged  = 0x0104,
	Cmd_ActiveFile         = 0x0105
};

/* Events */
enum Events
{
	Event_Click        = 0xAAAB,
	Event_DblClick     = 0xAAAC,
	Event_Change       = 0xAAAD,
	Event_MouseDown    = 0xAAAE,
	Event_MouseUp      = 0xAAAF,
	Event_MouseMove    = 0xAAB0,
	Event_KeyDown      = 0xAAB1,
	Event_KeyUp        = 0xAAB2,
	Event_KeyPress     = 0xAAB3,
	Event_Close        = 0xAAB4,
	Event_PageChange   = 0xAAB5,
	Event_Resize       = 0xAAB6,
	Event_Popup        = 0xAAD7
};

/* Widgets */
enum Widgets
{
	Wdg_Menu             = 0x0001,
	Wdg_PopupMenu        = 0x0002,
	Wdg_SubMenu          = 0x0003,
	Wdg_MenuItem         = 0x0004,
	Wdg_PageControl      = 0x0005,
	Wdg_Sheet            = 0x0006,
	Wdg_Edit             = 0x0007,
	Wdg_Button           = 0x0008,
	Wdg_CheckBox         = 0x0009,
	Wdg_GroupBox         = 0x000A,
	Wdg_RadioGroup       = 0x000B,
	Wdg_ListBox          = 0x000C,
	Wdg_ListView         = 0x000D,
	Wdg_TreeView         = 0x000E,
	Wdg_ModerPageControl = 0x000F,
	Wdg_ModerSheet       = 0x0010,
	Wdg_Panel            = 0x0011,
	Wdg_Shape            = 0x0012,
	Wdg_Window           = 0x0013,
	Wdg_MsgBox           = 0x0014,
	Wdg_RadioButton      = 0x0015,
	Wdg_ComboBox         = 0x0016,
	Wdg_Label            = 0x0017,
	Wdg_Memo             = 0x0018,
	Wdg_Plugin           = 0xFFFF
};

/* ShortCut */
enum ShortCut
{
	Sc_None  = 0x0000,
	Sc_Shift = 0x2000,
	Sc_Ctrl  = 0x4000,
	Sc_Alt   = 0x8000
};

/* WindowBorder */
enum WindowBorder
{
	Wb_Sizeable    = 0x0000,
	Wb_Dialog      = 0x0001,
	Wb_Single      = 0x0002,
	Wb_ToolWindow  = 0x0003,
	Wb_SizeToolWin = 0x0004,
	Wb_None        = 0x0005
};

/* CloseAction */
enum CloseAction
{
	Ca_None     = 0x00,
	Ca_Hide     = 0x01,
	Ca_Free     = 0x02,
	Ca_Minimize = 0x03
};

/* MsgBoxFlags */
enum MsgBoxFlags
{
  Mf_Ok               = 0x0000,
  Mf_OkCancel         = 0x0001,
  Mf_AbortRetryIgnore = 0x0002,
  Mf_YesNoCancel      = 0x0003,
  Mf_YesNo            = 0x0004,
  Mf_RetryCancel      = 0x0005,

  Mf_IconError        = 0x0010,
  Mf_IconQuestion     = 0x0020,
  Mf_IconWarning      = 0x0030,
  Mf_IconInformation  = 0x0040,

  Mf_DefButton2       = 0x0100,
  Mf_DefButton3       = 0x0200,
  Mf_DefButton4       = 0x0300
};

/* MsgBoxResult */
enum MsgBoxResult
{
  Mr_Ok       = 1,
  Mr_Cancel   = 2,
  Mr_Abort    = 3,
  Mr_Retry    = 4,
  Mr_Ignore   = 5,
  Mr_Yes      = 6,
  Mr_No       = 7
};

/* SourceFileFlags */
enum SourceFileFlags
{  Sf_Modified = 1,  Sf_Saved    = 2,
  Sf_Selected = 4,
  Sf_Project  = 8
};

/* SourceFileType */
enum SourceFileType
{
  St_Project = 1,
  St_C = 2,
  St_CPP = 3,
  St_H = 4,
  St_RC = 5,
  St_Unknow = 6,
  St_Folder = 7
};

typedef struct dispatch_command_t
{
	int command;
	int widget;
	int param;
	void* data;
} DispatchCommand;

typedef struct window_t
{
	int parent_id;
	int x;
	int y;
	int width;
	int height;
	const char * text;
	int border;
} Window;

typedef struct button_t
{
	int parent_id;
	int x;
	int y;
	int width;
	int height;
	const char * text;
} Button;

typedef struct checkbox_t
{
	int parent_id;
	int x;
	int y;
	int width;
	int height;
	const char * text;
} CheckBox;

typedef struct edit_t
{
	int parent_id;
	int x;
	int y;
	int width;
	int height;
} Edit;


typedef struct label_t
{
	int parent_id;
	int x;
	int y;
	int width;
	int height;
	const char * text;
} Label;

typedef struct menu_t
{
	int parent_id;
	int image_list;
} Menu;

typedef struct menu_item_t
{
	int submenu_id;
	int image_index;
	int position;
	const char * text;
	unsigned short shortcut;
} MenuItem;

typedef struct msg_box_t
{
	int parent_id;
	const char* text;
	const char* title;
	unsigned int utype;
} MsgBox;

typedef struct source_file_t
{
	char file_name[260];
	unsigned int flags;
	int utype;
} SourceFile;

#endif /* _PLUGIN_CMD_H_ */
