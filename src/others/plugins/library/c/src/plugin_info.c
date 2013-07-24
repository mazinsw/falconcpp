#include "plugin_info.h"
#include <string.h>

void PluginInfo_setVersion(PluginInfo * plg_info, const char* version)
{
	strncpy(plg_info->version, version, 30);
}

void PluginInfo_setName(PluginInfo * plg_info, const char* name)
{
	strncpy(plg_info->name, name, 100);
}

void PluginInfo_setAuthor(PluginInfo * plg_info, const char* author)
{
	strncpy(plg_info->author, author, 100);
}

void PluginInfo_setDescription(PluginInfo * plg_info, const char* description)
{
	strncpy(plg_info->description, description, 254);
}

const char* PluginInfo_getVersion(PluginInfo * plg_info)
{
	return plg_info->version;
}

const char* PluginInfo_getName(PluginInfo * plg_info)
{
	return plg_info->name;
}

const char* PluginInfo_getAuthor(PluginInfo * plg_info)
{
	return plg_info->author;
}

const char* PluginInfo_getDescription(PluginInfo * plg_info)
{
	return plg_info->description;
}
