#include "plugin.h"
#include <stdlib.h>
#define FCPLG_VERSION "1.1"

#ifdef WIN32
# include <windows.h>
# define WM_FALCONCPP_PLUGIN (WM_USER + 0x1221)
#else
# define WM_FALCONCPP_PLUGIN 0x1621
# define SendMessage(a, b, c, d) (0)
typedef unsigned long int HWND;
#endif

struct plugin_t
{
	HWND handle;
	int id;
	void * data;
	PluginInfo info;
	DispatchFn fn;
};

void Plugin_setDispatchFunction(Plugin* plugin, DispatchFn fn)
{
	plugin->fn = fn;
}

void Plugin_setData(Plugin* plugin, void* data)
{
	plugin->data = data;
}

void* Plugin_getData(Plugin* plugin)
{
	return plugin->data;
}

PluginInfo* Plugin_getInfo(Plugin* plugin)
{
	return &plugin->info;
}

int Plugin_sendCommand(Plugin* plugin, int command, int widget, int param, 
	void* data)
{
	DispatchCommand msg;
	
	msg.command = command;
	msg.widget = widget;
	msg.param = param;
	msg.data = data;
	return SendMessage(plugin->handle, WM_FALCONCPP_PLUGIN, plugin->id, (LPARAM)&msg);
}

DECLSPEC const char* FCPCALL Plugin_getVersion()
{
	return FCPLG_VERSION;
}

/**                            private section                               **/
DECLSPEC int FCPCALL Plugin_initialize(int handle, PluginInfo* info, void** data)
{
	Plugin* plg;
	
	plg = (Plugin*)malloc(sizeof(Plugin));
	if(plg == NULL)
		return 0;
	// prevent call sendCommand function on Plugin_main
	plg->handle = 0;
	plg->id = 0;
	plg->data = NULL;
	plg->fn = NULL;
	plg->id = Plugin_main(plg);
	if(plg->id <= 0)
	{
		int id = plg->id;
		free(plg);
		return id;
	}
	plg->handle = (HWND)handle;
	*data = plg;
	PluginInfo_setVersion(info, PluginInfo_getVersion(&plg->info));
	PluginInfo_setName(info, PluginInfo_getName(&plg->info));
	PluginInfo_setAuthor(info, PluginInfo_getAuthor(&plg->info));
	PluginInfo_setDescription(info, PluginInfo_getDescription(&plg->info));
	return plg->id;
}

DECLSPEC int FCPCALL Plugin_dispatchCommand(DispatchCommand* msg, 
	void* data)
{
	Plugin* plugin = (Plugin*)data;
	if(plugin->fn == NULL)
		return -1;
	return plugin->fn(plugin, msg->command, msg->widget, msg->param, msg->data);
}

DECLSPEC void FCPCALL Plugin_finalize(void* data)
{
	Plugin* plugin = (Plugin*)data;
	free(plugin);
}
