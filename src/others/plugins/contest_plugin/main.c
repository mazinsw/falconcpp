#include <fcplg/plugin.h>
#include <stdlib.h>
#include <string.h>

#define MY_PLUGIN_ID 0xC073

typedef struct ContestPlugin
{
	int open_cmd_menu_item;
	int enable_tool_checkbox;
} ContestPlugin;

int DispatchProc(Plugin* plugin, int command, int widget, int param, void* data);

int Plugin_main(Plugin* plugin)
{
	static ContestPlugin myplg;
	PluginInfo* info;
	
	memset(&myplg, 0, sizeof(ContestPlugin));
	info = Plugin_getInfo(plugin);
	PluginInfo_setName(info, "Contest");
	PluginInfo_setVersion(info, "1.0");
	PluginInfo_setAuthor(info, "Mazinsw");
	PluginInfo_setDescription(info, "Tools for programming contest");
	Plugin_setDispatchFunction(plugin, DispatchProc);
	Plugin_setData(plugin, &myplg);
	return MY_PLUGIN_ID;
}

int DispatchProc(Plugin* plugin, int command, int widget, int param, void* data)
{
	ContestPlugin* myplg = (ContestPlugin*)Plugin_getData(plugin);

	switch(command)
	{
	case Cmd_Create:
		if(widget == MY_PLUGIN_ID)
		{
			// create menu item before Open menu item on popup menu projects
			myplg->open_cmd_menu_item = Plugin_MenuItem_create(plugin, "Open cmd",
				MENUITEM_PROJECT_OPEN, -1, 0, POPUPMENU_PROJECT);
		}
		break;
	case Cmd_Click:
		if(widget == myplg->open_cmd_menu_item)
		{
			system("ConsoleRunner cmd /k");
		}
		break;
	case Cmd_Popup:
		if(widget == POPUPMENU_PROJECT)
		{
			SourceFile sf;
			int enabled = Plugin_SourceFile_getSelected(plugin, &sf) == 0;
			if(enabled)
				enabled = (sf.flags & Sf_Saved) == Sf_Saved;
			Plugin_sendCommand(plugin, Cmd_Enabled, myplg->open_cmd_menu_item, enabled, 0);
		}
		break;
	default:
		break;
	}
	return 0;
}
