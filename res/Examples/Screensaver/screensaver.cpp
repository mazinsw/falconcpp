/*
 *
 *	Project:	ScreenSaver
 *	Filename:	ScreenSaver.cpp
 *	Version:	0.0.001
 *	Date:		2005-02-20
 *
 *	Abstract:	Utility class for implementing screen savers, implementation
 *
 *	History:
 *	0.0.001		Initial version
 *
 *
 *
 *
 *
 *	Copyright (C) 2000-2005 Esaro Intergalactic
 *	No rights reserved.
 *
 */
#include "screensaver.h"
#include <mmsystem.h>
#define COMPILE_MULTIMON_STUBS



static LPCSTR kszWndObj = "WindowObj";
static LPCSTR kszWindowClass = "se.esaro.screensaver";
typedef VOID (WINAPI *PWDCHANGEPASSWORD)(LPCSTR, HWND, UINT, UINT);
typedef BOOL (WINAPI *VERIFYSCREENSAVEPWD)(HWND hwnd);
typedef int (WINAPI *XGETSYSTEMMETRICS)(int val);

LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);


BOOL CALLBACK EnumMonitorCallback(
  HMONITOR hMonitor,  // handle to display monitor
  HDC hdcMonitor,     // handle to monitor-appropriate device context
  LPRECT lprcMonitor, // pointer to monitor intersection rectangle
  LPARAM dwData       // data passed from EnumDisplayMonitors
)
{
	LPRECT rct = (LPRECT)dwData;
	UnionRect(rct, rct, lprcMonitor);
	return TRUE;
}

void GetFullScreenRect(LPRECT inRct)
{
	RECT rct={0,0,0,0};
	EnumDisplayMonitors (
	  NULL,                   // handle to a display device context 
	  NULL,          // specifies a clipping rectangle 
	  EnumMonitorCallback,  // pointer to a callback function
	  (LPARAM)&rct              // data passed to the callback function 
	);
	CopyRect(inRct, &rct);
}

ScreenSaver::ScreenSaver()
: m_wndParent(NULL), m_cmd(CMD_CONFIG), m_dwThreshold(60), m_lastUpdate(0)
{
	m_ptMouse.x = 0;
	m_ptMouse.y = 0;
}

BOOL ScreenSaver::Initialize(HINSTANCE hInst, int nCmdShow)
{
	m_hInst = hInst;

	return TRUE;
}

/*

	Command line params for screen savers

	"/s"		start saving the screen (full size)
	"/p wnd"		show a preview (with wnd as parent window)
	"/a wnd"		change the password
	"/c wnd"		do the config dialog

  */
BOOL ScreenSaver::Run(LPCSTR lpCmdLine)
{
	LPSTR szCpy;
	LPCSTR pch;

	szCpy = strdup(lpCmdLine);
	strlwr(szCpy);

	// MessageBox(NULL, lpCmdLine, "Cmd", MB_ICONSTOP);
	pch = strchr(lpCmdLine, '/');
	if(!pch){
	}
	else{
		pch++;
		switch(*pch){
			case 'a':
				m_cmd = CMD_CHANGE_PASSWORD;
				m_wndParent = GetWindowParam(pch + 1);
				break;
			case 'S': // Explorer double click
			case 's': // really go for it
				m_cmd = CMD_FULLSCREEN;
				break;
			case 'p':
				m_wndParent = GetWindowParam(pch + 1);
				m_cmd = CMD_PREVIEW;
				break;
			case 'c':
				m_wndParent = GetWindowParam(pch + 1);
				m_cmd = CMD_CONFIG;
				break;
		}
	}

	DWORD dwStyle = WS_OVERLAPPEDWINDOW;
	DWORD dwExStyle = 0;
	RECT rct = {0, 0, 100, 100};
	HMENU hMenu = NULL;

	switch(m_cmd){
		case CMD_CONFIG:
			DoConfigDialog(m_wndParent);
			return TRUE;
		case CMD_PREVIEW:
			dwStyle = WS_CHILD;
			GetClientRect(m_wndParent, &rct);
			hMenu = (HMENU)0xefef;
			break;
		case CMD_FULLSCREEN:
			dwStyle = WS_POPUP;
#ifndef _DEBUG
			dwExStyle = WS_EX_TOPMOST;
#endif
			m_wndParent = NULL;
			GetFullScreenRect(&rct);
			break;
		case CMD_CHANGE_PASSWORD:
			ChangePassword(m_wndParent);
			return TRUE;
	};

	free(szCpy);

	RegisterClass();
	
	if((m_hWnd = CreateWindowEx(dwExStyle, kszWindowClass, NULL, dwStyle,
		rct.left, rct.top, rct.right - rct.left, rct.bottom - rct.top,
		m_wndParent, NULL, m_hInst, NULL)) == NULL)
		return FALSE;

	SetProp(m_hWnd, kszWndObj, (HANDLE)this);
	
	ShowWindow(m_hWnd, m_nCmdShow);
	if(m_cmd == CMD_FULLSCREEN)
		ShowCursor(FALSE);
	UpdateWindow(m_hWnd);

	MSG msg;
	// Main message loop:
	while(TRUE){
		if(PeekMessage(&msg, NULL, 0, 0, PM_NOREMOVE)){
			if(GetMessage(&msg, NULL, 0, 0) == 0)
				break;
			DispatchMessage(&msg);
				
		}
		else{
			DWORD dwNow;

			dwNow = timeGetTime();
			if((dwNow - m_lastUpdate) > m_dwThreshold)
			{
				RECT rect;
				HDC hDC;
				GetClientRect(m_hWnd,&rect);
				hDC = GetDC(m_hWnd);
				UpdateScreen(hDC, &rect);
				m_lastUpdate = dwNow;
				ReleaseDC(m_hWnd, hDC);
			}
		}
	}

	return msg.wParam;
}

BOOL ScreenSaver::Exitialize()
{
	return TRUE;
}

LRESULT ScreenSaver::OnMessage(UINT message, WPARAM wParam, LPARAM lParam)
{
	POINT pt;
	switch (message) 
	{
		/* the things that kill us */
		case WM_MOUSEMOVE:
			if(m_cmd != CMD_FULLSCREEN)
				break;
			pt.x = LOWORD(lParam);
			pt.y = HIWORD(lParam);
			if((m_ptMouse.x == 0)&&(m_ptMouse.y == 0))
			{
				m_ptMouse.x = pt.x;
				m_ptMouse.y = pt.y;
			}
			else{
				if((abs(pt.x - m_ptMouse.x) > 3)||(abs(pt.y - m_ptMouse.y) > 3))
					PostMessage(m_hWnd, WM_CLOSE, 0, 0);
			}
			break;
		case WM_ACTIVATE:
			if(LOWORD(wParam) == WA_INACTIVE)
				PostMessage(m_hWnd, WM_CLOSE, 0, 0);
			break;
		case WM_ACTIVATEAPP:
			if((BOOL)wParam == FALSE)
				PostMessage(m_hWnd, WM_CLOSE, 0, 0);
			break;
		case WM_SYSKEYDOWN:
		case WM_KEYDOWN:
			if(m_cmd != CMD_FULLSCREEN)
				break;
			PostMessage(m_hWnd, WM_CLOSE, 0, 0);
			break;
		/* the app dies with the window */
		case WM_DESTROY:
			PostQuitMessage(0);
			break;
		case WM_CLOSE:
			DestroyWindow(m_hWnd);
			return 0;
		default:
			return DefWindowProc(m_hWnd, message, wParam, lParam);
   }
   return 0;
}

void ScreenSaver::ChangePassword(HWND hwnd)
{
	PWDCHANGEPASSWORD PwdChangePassword;;
	HINSTANCE hLib;;

	if ((hLib = LoadLibrary("MPR.DLL")) == NULL)
		return;
	if ((PwdChangePassword = (PWDCHANGEPASSWORD)::
		GetProcAddress(hLib,"PwdChangePasswordA")) == NULL)
	{
		FreeLibrary(hLib);
		return;
	}
	PwdChangePassword("SCRSAVE", hwnd, 0, 0);
	FreeLibrary(hLib);
}

BOOL ScreenSaver::VerifyPassword(HWND hwnd)
{ 
	BOOL rslt;
	VERIFYSCREENSAVEPWD VerifyScreenSavePwd;
	HINSTANCE hLib;
	OSVERSIONINFO osv;

	osv.dwOSVersionInfoSize=sizeof(osv);
	GetVersionEx(&osv);
	if (osv.dwPlatformId==VER_PLATFORM_WIN32_NT)
		return TRUE;

	hLib=LoadLibrary("PASSWORD.CPL");
	if(hLib==NULL)
	{
		return TRUE;
	}
	VerifyScreenSavePwd=
		(VERIFYSCREENSAVEPWD)GetProcAddress(hLib,"VerifyScreenSavePwd");
	if (VerifyScreenSavePwd==NULL)
	{ 
		FreeLibrary(hLib);return TRUE;
	}
	rslt = VerifyScreenSavePwd(hwnd);
	FreeLibrary(hLib);
	return rslt;
}
ATOM ScreenSaver::RegisterClass()
{
	WNDCLASSEX wcex;

	wcex.cbSize = sizeof(WNDCLASSEX); 

	wcex.style			= CS_HREDRAW | CS_VREDRAW;
	wcex.lpfnWndProc	= (WNDPROC)::WndProc;
	wcex.cbClsExtra		= 0;
	wcex.cbWndExtra		= 0;
	wcex.hInstance		= m_hInst;
	wcex.hIcon			= NULL;
	wcex.hCursor		= LoadCursor(NULL, IDC_ARROW);
	wcex.hbrBackground	= CreateSolidBrush(RGB(0x00, 0x00, 0x00));
	wcex.lpszMenuName	= NULL;
	wcex.lpszClassName	= kszWindowClass;
	wcex.hIconSm		= NULL;

	return RegisterClassEx(&wcex);
}

HWND ScreenSaver::GetWindowParam(LPCSTR pch)
{
	pch = strpbrk(pch, "123456789abcdef");
	if(!pch)
		return NULL;
	return (HWND)atol(pch);
}


LRESULT CALLBACK WndProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	static HWND hCache = NULL;
	static MsgTarget* pMsgTarget = NULL;

	if((hWnd == hCache)&&(pMsgTarget != NULL)){
		// same window as last time, use object directly
        MessageBeep(64);
		return pMsgTarget->OnMessage(uMsg, wParam, lParam);
	}

	// get the window object property
	pMsgTarget = (MsgTarget*)GetProp(hWnd, kszWndObj);
	if(pMsgTarget){
		return pMsgTarget->OnMessage(uMsg, wParam, lParam);
	}

	// not our kind of window
	return DefWindowProc(hWnd, uMsg, wParam, lParam);
}


