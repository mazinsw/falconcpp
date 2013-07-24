#include <fcplg/plugin.h>

#define MY_PLUGIN_ID 0x5412

int DispatchProc(Plugin* plugin, int command, int widget, int param, void* data);

int Plugin_main(Plugin* plugin)
{
	PluginInfo* info;
	
	info = Plugin_getInfo(plugin);
	PluginInfo_setName(info, "My Plugin");
	PluginInfo_setVersion(info, "1.0");
	PluginInfo_setAuthor(info, "Fulano");
	PluginInfo_setDescription(info, "Test plugin");
	Plugin_setDispatchFunction(plugin, DispatchProc);
	Plugin_setData(plugin, info);
	return MY_PLUGIN_ID;
}

int DispatchProc(Plugin* plugin, int command, int widget, int param, void* data)
{
	switch(command)
	{
	case Cmd_Get:
		if(widget == Wdg_Plugin)
		{
			if(param == Prop_Info)
			{
				PluginInfo* myinfo = Plugin_getData(plugin);
				PluginInfo* info = (PluginInfo*)data;
				
				PluginInfo_setVersion(info, PluginInfo_getVersion(myinfo));
				PluginInfo_setName(info, PluginInfo_getName(myinfo));
				PluginInfo_setAuthor(info, PluginInfo_getAuthor(myinfo));
				PluginInfo_setDescription(info, PluginInfo_getDescription(myinfo));
			}
		}
		break;
	default:
		break;
	}
	return 0;
}
