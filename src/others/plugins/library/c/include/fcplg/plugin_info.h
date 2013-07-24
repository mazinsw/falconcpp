#ifndef _PLUGIN_INFO_H_
#define _PLUGIN_INFO_H_

typedef struct plugin_info_t
{
	char version[31];
	char name[101];
	char author[101];
	char description[255];
} PluginInfo;

#include "plugin_begin.h"
/* Set up for C function definitions, even when using C++ */
#ifdef __cplusplus
extern "C" {
#endif

void PluginInfo_setVersion(PluginInfo * plg_info, const char * version);
void PluginInfo_setName(PluginInfo * plg_info, const char * name);
void PluginInfo_setAuthor(PluginInfo * plg_info, const char * author);
void PluginInfo_setDescription(PluginInfo * plg_info, const char * description);
const char* PluginInfo_getVersion(PluginInfo * plg_info);
const char* PluginInfo_getName(PluginInfo * plg_info);
const char* PluginInfo_getAuthor(PluginInfo * plg_info);
const char* PluginInfo_getDescription(PluginInfo * plg_info);

/* Ends C function definitions when using C++ */
#ifdef __cplusplus
}
#endif
#include "plugin_end.h"

#endif /* _PLUGIN_INFO_H_ */