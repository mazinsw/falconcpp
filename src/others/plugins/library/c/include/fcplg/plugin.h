#ifndef _PLUGIN_H_
#define _PLUGIN_H_
#include "plugin_cmd.h"
#include "plugin_info.h"
#include "plugin_begin.h"

typedef struct plugin_t Plugin;
#include "plugin_main.h"

typedef int (*DispatchFn)(Plugin* plugin, int command, 
	int widget, int param, void* data);

/* Set up for C function definitions, even when using C++ */
#ifdef __cplusplus
extern "C" {
#endif

void Plugin_setDispatchFunction(Plugin* plugin, DispatchFn fn);
void Plugin_setData(Plugin* plugin, void* data);
void* Plugin_getData(Plugin* plugin);
PluginInfo* Plugin_getInfo(Plugin* plugin);

int Plugin_sendCommand(Plugin* plugin, int command, int widget, int param, void* data);

/* Ends C function definitions when using C++ */
#ifdef __cplusplus
}
#endif
#include "plugin_end.h"

#endif /* _PLUGIN_H_ */