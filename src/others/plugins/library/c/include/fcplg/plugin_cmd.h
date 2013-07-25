#ifndef _PLUGIN_CMD_H_
#define _PLUGIN_CMD_H_

/* Commands */
enum Commands {
	Cmd_Create             = 0x0001,
	Cmd_Free               = 0x0002,
	Cmd_Destroy            = 0x0003,
	Cmd_Get                = 0x0004,
	Cmd_Set                = 0x0005,
	Cmd_CompilerChanged    = 0x0006,
	Cmd_LangChanged        = 0x0007,
	Cmd_TabClosing         = 0x0008,
	Cmd_TabClosed          = 0x0009,
	Cmd_Select             = 0x000A,
	Cmd_Click              = 0x000B,
	Cmd_MouseDown          = 0x000C,
	Cmd_MouseUp            = 0x000D,
	Cmd_MouseMove          = 0x000E,
	Cmd_KeyDown            = 0x000C,
	Cmd_KeyUp              = 0x000D,
	Cmd_KeyPress           = 0x000E,
	Cmd_FileSelected       = 0x000F,
	Cmd_FileDeleted        = 0x0010,
	Cmd_PosChanged         = 0x0011,
	Cmd_SizeChanged        = 0x0012,
	Cmd_ScreenModeChanged  = 0x0013,
	Cmd_Show               = 0x0014,
	Cmd_Hide               = 0x0015,
	Cmd_ShowModal          = 0x0016
};

/* Properties */
enum Properties {
	Prop_Text               = 0x0001,
	Prop_Size               = 0x0002,
	Prop_Info               = 0x0003, // Plugin info
	Prop_Name               = 0x0004,
//Prop_MAX_ID               = 0xAAAA,
};

/* Events */
enum Events {
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
	Event_Resize       = 0xAAB6
};

/* Widgets */
enum Widgets {
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
	Wdg_List             = 0x000C,
	Wdg_ListView         = 0x000D,
	Wdg_TreeView         = 0x000E,
	Wdg_ModerPageControl = 0x000F,
	Wdg_ModerSheet       = 0x0010,
	Wdg_Panel            = 0x0011,
	Wdg_Shape            = 0x0012,
	Wdg_Window           = 0x0013,
	Wdg_MsgBox           = 0x0014,
	Wdg_Plugin           = 0xFFFF
};

/* ShortCut */
enum ShortCut {
  Sc_None  = 0x0000,
  Sc_Shift = 0x2000,
  Sc_Ctrl  = 0x4000,
  Sc_Alt   = 0x8000
};

/* WindowBorder */
enum WindowBorder {
  Wb_Sizeable    = 0x0000,
  Wb_Dialog      = 0x0001,
  Wb_Single      = 0x0002,
  Wb_ToolWindow  = 0x0003,
  Wb_SizeToolWin = 0x0004,
  Wb_None        = 0x0005
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

#endif /* _PLUGIN_CMD_H_ */