#ifndef _PLUGIN_CMD_H_
#define _PLUGIN_CMD_H_

/* Commands */
enum Commands {
	Cmd_Create           = 0x0001,
	Cmd_Free             = 0x0002,
	Cmd_Destroy          = 0x0003,
	Cmd_Get              = 0x0004,
	Cmd_SetProperty      = 0x0005,
	Cmd_SetEvent         = 0x0006,
	Cmd_Call             = 0x0007
};

/* Properties */
enum Properties {
	Prop_Text            = 0x0001,
	Prop_Size            = 0x0002,
	Prop_Info            = 0x0003 // Plugin info
};
  /* Widgets */
enum Widgets {
	Wdg_Menu             = 0x0001,
	Wdg_SubMenu          = 0x0002,
	Wdg_PageControl      = 0x0003,
	Wdg_Sheet            = 0x0004,
	Wdg_Edit             = 0x0005,
	Wdg_Button           = 0x0006,
	Wdg_CheckBox         = 0x0007,
	Wdg_GroupBox         = 0x0008,
	Wdg_RadioGroup       = 0x0009,
	Wdg_List             = 0x000A,
	Wdg_ListView         = 0x000B,
	Wdg_TreeView         = 0x000C,
	Wdg_ModerPageControl = 0x000D,
	Wdg_ModerSheet       = 0x000E,
	Wdg_Plugin           = 0xFFFF
};

typedef struct dispatch_t
{
	int command;
	int widget;
	int param;
	void* data;
} DispatchCommand;

#endif /* _PLUGIN_CMD_H_ */