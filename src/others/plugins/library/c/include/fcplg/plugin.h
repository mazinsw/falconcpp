#ifndef _PLUGIN_H_
#define _PLUGIN_H_

typedef struct plugin_t Plugin;

#include "plugin_cmd.h"
#include "plugin_info.h"
#include "plugin_wdg_map.h"
#include "plugin_widgets.h"
#include "plugin_utils.h"
#include "plugin_main.h"

typedef int (*DispatchFn)(Plugin* plugin, int command, 
	int widget, int param, void* data);

#include "plugin_begin.h"
/* Set up for C function definitions, even when using C++ */
#ifdef __cplusplus
extern "C" {
#endif

void Plugin_setDispatchFunction(Plugin* plugin, DispatchFn fn);
void Plugin_setData(Plugin* plugin, void* data);
void* Plugin_getData(Plugin* plugin);

/**
 * Get Plugin Information
 * 
 * parameters
 *   plugin: your plugin instance passed by DispachFnm or Plugin_main function
 * 
 * return
 *   return PluginInfo pointer to struct
 */
PluginInfo* Plugin_getInfo(Plugin* plugin);

/**
 * Get plugin library version
 * 
 * return
 *   C string containing the version number
 */
DECLSPEC const char* FCPCALL Plugin_getVersion();

/**
 * Send a command to Falcon C++ IDE
 * 
 * parameters
 *   plugin: your plugin instance passed by DispachFn function
 *   command: any command found at plugin_cmd.h header
 *   widget: who widget you needs change or retrieve
 *   param: a property in the most cases
 *   data: a value for property
 * 
 * return
 *   return depends on command, in the most case is 0
 */
int Plugin_sendCommand(Plugin* plugin, int command, int widget, int param, void* data);

/* Ends C function definitions when using C++ */
#ifdef __cplusplus
}
#endif
#include "plugin_end.h"

#endif /* _PLUGIN_H_ */