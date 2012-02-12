/*
 *
 *	Project:	ScreenSaver
 *	Filename:	ScreenSaver.cpp
 *	Version:	0.0.001
 *	Date:		2005-02-20
 *
 *	Abstract:	Utility class for implementing Win32 screen savers, interface
 *
 *	History:
 *	0.0.001		Initial version
 *
 *
 *
 *	Usage:
 *
 *	To use this module, you need to subclass the ScreenSaver class.
 *	In your WinMain function, create an instance of your subclassed class,
 *	and call the member functions Initialize, Run and Exitialize (in that
 *	order) with the obvious parameters:
 *
 *	int APIENTRY WinMain(HINSTANCE hInstance,
 *                    HINSTANCE hPrevInstance,
 *                    LPSTR     lpCmdLine,
 *                    int       nCmdShow)
 *	{
 *		SubclassedClass theApp; 
 *		if(!theApp.Initialize(hInstance, nCmdShow))
 *			return -1;
 *		theApp.Run(lpCmdLine);
 *		theApp.Exitialize();
 *		return 0;
 *	}
 *
 *
 *	You need to override the following two member functions to display
 *	your screen saver:
 *
 *	void UpdateScreen(HDC dc, LPRECT rct);
 *	virtual void DoConfigDialog();
 *
 *
 *	UpdateScreen
 *	------------
 *	The UpdateScreen function is called from the message loop when m_dwThreshold
 *	milliseconds has elapsed since the last update call. This value is set ini-
 *	tially to 40 - giving you 25 updates per second, unless the system is busy
 *	doing other stuff. Note that the timer relies on timeGetTime - not a very
 *	precise system timer. Unless your compiler supports #pragma comment(lib, ...)
 *	you need to link with 'winmm.lib'.
 *		The rct parameter is the client rect of the screen saver window. Note that
 *	the size of the window is very much different when you are doing full-screen
 *	saving (ScreenSaver::m_cmd == CMD_FULLSCREEN) and when you are doing the
 *	preview in the Control Panel (ScreenSaver::m_cmd == CMD_PREVIEW).
 *
 *	DoConfigDialog
 *	------------
 *	The DoConfigDialog function is called when the user presses the Settings button
 *	in the Control Panel, or when the user selects Settings from the screen savers
 *	context menu in Windows Explorer. You should do something like this in your
 *	implementation of that function:
 *
 *		DialogBoxParam(m_hInst, MAKEINTRESOURCE(IDD_CONFIG), 
 *			wndParent, ConfigDialogProc, (LPARAM)this);
 *
 *	See the Win32 SDK docs for more info about creating dialog boxes.
 *
 *
 *	OnMessage
 *	---------
 *	You can optionally override OnMessage, for example if you dont want the
 *	window to be destroyed
 *
 *	This class takes care of
 *
 *	1.	Parameter parsing
 *	2.	Window class registration
 *	3.	Creation of screen saver window
 *	4.	Message loop
 *	5.	Destruction of screen saver window
 *	6.	Displaying the change password dialog (pre-NT)
 *	7.	Displaying the verify password dialog (pre-NT)
 *
 *
 *	Copyright (C) 2000-2005 Esaro Intergalactic
 *	All rights reserved.
 *
 */
#include <windows.h>

#define MAX_LOADSTRING 100

class MsgTarget
{
public:
	virtual LRESULT OnMessage(UINT message, WPARAM wParam, LPARAM lParam) = 0;
};


class ScreenSaver : public MsgTarget
{
public:
	ScreenSaver();
	virtual BOOL Initialize(HINSTANCE hInst, int nCmdShow);
	virtual BOOL Run(LPCSTR lpCmdLine);
	virtual BOOL Exitialize();
	virtual LRESULT OnMessage(UINT message, WPARAM wParam, LPARAM lParam);
	virtual void DoConfigDialog(HWND wndParent){};
	virtual void UpdateScreen(HDC dc, LPRECT rct){};
	virtual void ChangePassword(HWND wndParent);
	virtual BOOL VerifyPassword(HWND wndParent);

	HINSTANCE m_hInst;

	/* don't contaminate the global namespace */
	typedef enum
	{
		CMD_CONFIG,
		CMD_FULLSCREEN,
		CMD_PREVIEW,
		CMD_CHANGE_PASSWORD,
		CMD_NONE
	}COMMAND;
protected:
	ATOM RegisterClass();
	HWND m_wndParent;
	int m_nCmdShow;
	COMMAND m_cmd;
	HWND m_hWnd;
	HWND GetWindowParam(LPCSTR pch);
	DWORD m_lastUpdate;
	DWORD m_dwThreshold;
	POINT m_ptMouse;
};
