#ifndef _PLUGIN_WIDGETS_H_
#define _PLUGIN_WIDGETS_H_
#include "plugin.h"

#include "plugin_begin.h"
/* Set up for C function definitions, even when using C++ */
#ifdef __cplusplus
extern "C" {
#endif

int Plugin_Window_create(Plugin* plugin, const char* text, int x, int y, 
	int width, int height, int border, int parent_id);

int Plugin_Button_create(Plugin* plugin, const char * text, int x, int y, 
	int width, int height, int parent_id);

int Plugin_CheckBox_create(Plugin* plugin, const char * text, int x, int y, 
	int width, int height, int parent_id);

int Plugin_Edit_create(Plugin* plugin, int x, int y, 
	int width, int height, int parent_id);

int Plugin_Label_create(Plugin* plugin, const char * text, int x, int y, 
	int width, int height, int parent_id);

int Plugin_Menu_create(Plugin* plugin, int image_list, int parent_id);

int Plugin_MenuItem_create(Plugin* plugin, const char * text, int position, 
	int image_index, unsigned short shortcut, int submenu_id);

int Plugin_MsgBox_show(Plugin* plugin, int parent_id, const char* text, 
	const char* title, unsigned int utype);

int Plugin_SourceFile_getActive(Plugin* plugin, SourceFile * source);
int Plugin_SourceFile_getSelected(Plugin* plugin, SourceFile * source);

/* Ends C function definitions when using C++ */
#ifdef __cplusplus
}
#endif
#include "plugin_end.h"

#endif /* _PLUGIN_WIDGETS_H_ */