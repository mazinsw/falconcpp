#include "plugin_widgets.h"
#include "plugin_cmd.h"

int Plugin_Window_create(Plugin* plugin, const char* text, int x, int y, 
	int width, int height, int border, int parent_id)
{
	Window wnd;
	
	wnd.parent_id = parent_id;
	wnd.x = x;
	wnd.y = y;
	wnd.width = width;
	wnd.height = height;
	wnd.text = text;
	wnd.border = border;
	return Plugin_sendCommand(plugin, Cmd_Create, Wdg_Window, 0, &wnd);
}

int Plugin_Button_create(Plugin* plugin, const char* text, int x, int y, 
	int width, int height, int parent_id)
{
	Button btn;
	
	btn.parent_id = parent_id;
	btn.x = x;
	btn.y = y;
	btn.width = width;
	btn.height = height;
	btn.text = text;
	return Plugin_sendCommand(plugin, Cmd_Create, Wdg_Button, 0, &btn);
}

int Plugin_CheckBox_create(Plugin* plugin, const char* text, int x, int y, 
	int width, int height, int parent_id)
{
	CheckBox chb;
	
	chb.parent_id = parent_id;
	chb.x = x;
	chb.y = y;
	chb.width = width;
	chb.height = height;
	chb.text = text;
	return Plugin_sendCommand(plugin, Cmd_Create, Wdg_CheckBox, 0, &chb);
}

int Plugin_Edit_create(Plugin* plugin, int x, int y, 
	int width, int height, int parent_id)
{
	Edit edit;
	
	edit.parent_id = parent_id;
	edit.x = x;
	edit.y = y;
	edit.width = width;
	edit.height = height;
	return Plugin_sendCommand(plugin, Cmd_Create, Wdg_Edit, 0, &edit);
}

int Plugin_Label_create(Plugin* plugin, const char* text, int x, int y, 
	int width, int height, int parent_id)
{
	Label lbl;
	
	lbl.parent_id = parent_id;
	lbl.x = x;
	lbl.y = y;
	lbl.width = width;
	lbl.height = height;
	lbl.text = text;
	return Plugin_sendCommand(plugin, Cmd_Create, Wdg_Label, 0, &lbl);
}

int Plugin_Menu_create(Plugin* plugin, int image_list, int parent_id)
{
	Menu menu;
	
	menu.parent_id = parent_id;
	menu.image_list = image_list;
	return Plugin_sendCommand(plugin, Cmd_Create, Wdg_Menu, 0, &menu);
}

int Plugin_MenuItem_create(Plugin* plugin, const char* text, int position, 
	int image_index, unsigned short shortcut, int submenu_id)
{
	MenuItem item;
	
	item.text = text;
	item.position = position;
	item.image_index = image_index;
	item.shortcut = shortcut;
	item.submenu_id = submenu_id;
	return Plugin_sendCommand(plugin, Cmd_Create, Wdg_MenuItem, 0, &item);
}

int Plugin_MsgBox_show(Plugin* plugin, int parent_id, const char* text, 
	const char* title, unsigned int utype)
{
	MsgBox msgbox;
	
	msgbox.parent_id = parent_id;
	msgbox.text = text;
	msgbox.title = title;
	msgbox.utype = utype;
	return Plugin_sendCommand(plugin, Cmd_Create, Wdg_MsgBox, 0, &msgbox);
}

int Plugin_SourceFile_getActive(Plugin* plugin, SourceFile * source)
{	return Plugin_sendCommand(plugin, Cmd_ActiveFile, 0, 0, source);} 

int Plugin_SourceFile_getSelected(Plugin* plugin, SourceFile * source)
{
	return Plugin_sendCommand(plugin, Cmd_FileSelected, TREEVIEW_PROJECTS, 0, source);
}
