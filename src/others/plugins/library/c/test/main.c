#include <fcplg/plugin.h>
#include <stdlib.h>
#include <string.h>

#define MY_PLUGIN_ID 0x5412

typedef struct MyPlugin
{
	int menuitem;
	int form;
	int button;
	int edit;
	int label;
	int checkbox;
} MyPlugin;

int DispatchProc(Plugin* plugin, int command, int widget, int param, void* data);

int Plugin_main(Plugin* plugin)
{
	static MyPlugin myplg;
	PluginInfo* info;
	
	memset(&myplg, 0, sizeof(MyPlugin));
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
			myplg->menuitem = Plugin_MenuItem_create(plugin, "Plugin Test",
				MENUITEM_MAIN_TOOLS_PACKAGES, -1, 0, SUBMENU_MAIN_TOOLS);
			// create separator item before Tools->Packages menu item
			Plugin_MenuItem_create(plugin, "-",
				MENUITEM_MAIN_TOOLS_PACKAGES, -1, 0, SUBMENU_MAIN_TOOLS);
		}
		break;
	case Cmd_Click:
		if(widget == myplg->menuitem)
		{
			// create window
			myplg->form = Plugin_Window_create(plugin, "Window caption", -1, 
				-1, 300, 200, Wb_ToolWindow, WINDOW_MAIN);
			// create button
			myplg->button = Plugin_Button_create(plugin, "My Button", 20, 
				20, 100, 25, myplg->form);
			// create checkbox
			myplg->checkbox = Plugin_CheckBox_create(plugin, "My CheckBox", 130, 
				20, 100, 25, myplg->form);
			// create edit
			myplg->edit = Plugin_Edit_create(plugin, 20, 75, 150, 25, 
				myplg->form);
			// create label
			myplg->label = Plugin_Label_create(plugin, "My Label", 20, 
				55, 150, 20, myplg->form);
			Plugin_sendCommand(plugin, Cmd_ShowModal, myplg->form, 0, NULL);
			Plugin_sendCommand(plugin, Cmd_Free, myplg->form, 0, NULL);
		}
		else if(widget == myplg->button)
		{
			// show a message box
			Plugin_MsgBox_show(plugin, myplg->form, "My button click", "Button Click", Mf_Ok);
		}
		else if(widget == myplg->checkbox)
		{
			// show a message box
			Plugin_MsgBox_show(plugin, myplg->form, "My checkbox click", "CheckBox Click", Mf_Ok);
		}
		else if(widget == myplg->label)
		{
			// show a message box
			Plugin_MsgBox_show(plugin, myplg->form, "My label click", "Label Click", Mf_Ok);
		}
		break;
	case Cmd_Change:
		 if(widget == myplg->edit)
		{
			// show a message box
			Plugin_MsgBox_show(plugin, myplg->form, "My edit change text", "Edit Change", Mf_Ok);
		}
		break;
	case Cmd_Close:
		if(widget == myplg->form)
		{
			int r;

			// show a message box
			r = Plugin_MsgBox_show(plugin, myplg->form, "Close Window?", "Close event", Mf_YesNoCancel);
			if(r != Mr_Yes)
				*((int*)data) = Ca_None;
		}
		break;
	default:
		break;
	}
	return 0;
}
