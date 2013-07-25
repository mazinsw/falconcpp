#include <fcplg/plugin.h>
#include <stdlib.h>

#define MY_PLUGIN_ID 0x5412

typedef struct MyPlugin
{
	int menuitem_test;
	int menuitem_show_form;
} MyPlugin;

int DispatchProc(Plugin* plugin, int command, int widget, int param, void* data);

int Plugin_main(Plugin* plugin)
{
	static MyPlugin myplg;
	PluginInfo* info;
	
	info = Plugin_getInfo(plugin);
	PluginInfo_setName(info, "My Plugin");
	PluginInfo_setVersion(info, "1.0");
	PluginInfo_setAuthor(info, "Fulano");
	PluginInfo_setDescription(info, "Test plugin");
	Plugin_setDispatchFunction(plugin, DispatchProc);
	Plugin_setData(plugin, &myplg);
	return MY_PLUGIN_ID;
}

int DispatchProc(Plugin* plugin, int command, int widget, int param, void* data)
{
	MyPlugin* myplg = (MyPlugin*)Plugin_getData(plugin);

	switch(command)
	{
	case Cmd_Create:
		if(widget == MY_PLUGIN_ID)
		{
			// create menu item before Tools->Packages menu item
			myplg->menuitem_test = Plugin_MenuItem_create(plugin, "Plugin Test",
				MENUITEM_MAIN_TOOLS_PACKAGES, -1, 0, SUBMENU_MAIN_TOOLS);
			myplg->menuitem_show_form = Plugin_MenuItem_create(plugin, "Plugin Test - Show Form",
				MENUITEM_MAIN_TOOLS_PACKAGES, -1, 0, SUBMENU_MAIN_TOOLS);
			// create separator item before Tools->Packages menu item
			Plugin_MenuItem_create(plugin, "-",
				MENUITEM_MAIN_TOOLS_PACKAGES, -1, 0, SUBMENU_MAIN_TOOLS);
		}
		break;
	case Cmd_Click:
		if(widget == myplg->menuitem_test)
		{
			// show a message box
			Plugin_MsgBox_show(plugin, WINDOW_MAIN, "My plugin test", "Click event", 0);
		}
		else if(widget == myplg->menuitem_show_form)
		{
			int form;

			// show a message box
			form = Plugin_Window_create(plugin, "Window caption", -1, 
				-1, 300, 200, Wb_ToolWindow, WINDOW_MAIN);
			Plugin_sendCommand(plugin, Cmd_ShowModal, form, 0, NULL);
			Plugin_sendCommand(plugin, Cmd_Free, form, 0, NULL);
		}
		break;
	default:
		break;
	}
	return 0;
}
