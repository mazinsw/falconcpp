#include "plugin_widgets.h"
#include "plugin_cmd.h"

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
