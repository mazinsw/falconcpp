/*
 *
 *	Project:	Simple
 *	Filename:	Simple.cpp
 *	Version:	0.0.001
 *	Date:		2005-02-20
 *
 *	Abstract:	Simple subclassing of ScreenSaver
 *
 *	History:
 *	0.0.001		Initial version
 *
 *
 *
 *
 *
 *	Copyright (C) 2000-2005 Esaro Intergalactic
 *	No rights reserved. You may use this material for any purpose.
 *
 */
#include <windows.h>
#include "resource.h"
#include <stdio.h>
#include <commctrl.h>
#include <commdlg.h>
#include <math.h>
#include "screensaver.h"

#define MAX_CIRCLES 100

static LPCSTR kszAppSection = "SimpleScreenSaver";
static LPCSTR kszKeyCircleColor = "CircleColor";
static LPCSTR kszKeyNumCircles = "NumCircles";

/*
 *
 *	PRECISION_RECT, PRECISION_POINT and related functions
 *	-----------------------------------------------------
 *
 *	We use these instead of RECT & POINT to get the circle
 *	to bounce in a slightly irregular way
 *
 */
typedef struct _tag_PRECISION_RECT
{
	double left;
	double top;
	double right;
	double bottom;
}PRECISION_RECT;

typedef struct _tag_PRECISION_POINT
{
	double x;
	double y;
}PRECISION_POINT;

void OffsetPrecisionRect(PRECISION_RECT* rct, double dx, double dy)
{
	rct->left += dx;
	rct->top += dy;
	rct->right += dx;
	rct->bottom += dy;
}



inline double RectHeight(PRECISION_RECT* rct)
{
	return rct->bottom - rct->top;
}

inline double RectWidth(PRECISION_RECT* rct)
{
	return rct->right - rct->left;
}

inline void RectCenter(PRECISION_RECT* rct, PRECISION_POINT* pt)
{
	pt->x = rct->left + RectWidth(rct) / 2.0;
	pt->y = rct->top + RectHeight(rct) / 2.0;
}

BOOL DrawCircle(HDC dc, PRECISION_POINT* center, int nRadius)
{
	return Ellipse(dc, (int)center->x - nRadius, (int)center->y - nRadius, (int)center->x + nRadius, (int)center->y + nRadius);
}

/*
 *
 *	Circle
 *	------
 *	Knows how to initialize and draw itself
 *
 */
class Circle
{
public:
	Circle(COLORREF rgb) : m_fFirst(TRUE)
	{
		m_hPen = CreatePen(PS_SOLID, 1, rgb);
	};
	~Circle()
	{
		DeleteObject(m_hPen);
	};
	void Draw(HDC dc, LPRECT rct);
protected:
	void Init(LPRECT rctScreen);
	PRECISION_RECT m_rctDraw;
	double m_dx;
	double m_dy;
	int m_radius;
	BOOL m_fFirst;
	HPEN m_hPen;
};

void Circle::Init(LPRECT rct)
{
	int nScreenWidth;
	double angle;

	nScreenWidth = abs(rct->right - rct->left);
	angle = ((double)rand())/(double)RAND_MAX;
	m_dx = cos(angle)*30.0;
	m_dy = sin(angle)*30.0;
	m_radius = max(4,min(12, (int)(nScreenWidth/100)));
	m_rctDraw.left = (double)(rand() % 30);;
	m_rctDraw.right = m_rctDraw.left + (double)m_radius;
	m_rctDraw.top = (double)(rand() % 30);
	m_rctDraw.bottom = m_rctDraw.top + (double)m_radius;
}

void Circle::Draw(HDC dc, LPRECT rct)
{
	HGDIOBJ hOld;
	PRECISION_POINT pt;

	if(m_fFirst)
	{
		Init(rct);
		m_fFirst = FALSE;
	}

	RectCenter(&m_rctDraw, &pt);
	hOld = SelectObject(dc, GetStockObject(NULL_BRUSH));
	SelectObject(dc, GetStockObject(BLACK_PEN));
	DrawCircle(dc, &pt, m_radius);

	/* move the target rect*/
	OffsetPrecisionRect(&m_rctDraw, m_dx, m_dy);
	RectCenter(&m_rctDraw, &pt);
	if(pt.x > rct->right)
		m_dx = m_dx*-1.0;
	if(pt.y > rct->bottom)
		m_dy = m_dy*-1.0;
	if(pt.x < rct->left)
		m_dx = m_dx*-1.0;
	if(pt.y < rct->top)
		m_dy = m_dy*-1.0;

	RectCenter(&m_rctDraw, &pt);
	SelectObject(dc, m_hPen);
	DrawCircle(dc, &pt, m_radius);
	SelectObject(dc, hOld);
}

/*
 *
 *	SimpleSaver
 *	-----------
 *	Subclassed GDI screen saver. Responsible
 *	for creating the circles and displaying
 *	the config dialog
 *
 */
class SimpleSaver : public ScreenSaver
{
public:
	SimpleSaver();
	virtual BOOL Initialize(HINSTANCE hInst, int nCmdShow);
	virtual BOOL Exitialize();
	virtual LRESULT OnMessage(UINT message, WPARAM wParam, LPARAM lParam);

	/* params */
	COLORREF m_rgb;
	UINT m_nNumCircles;
protected:
	virtual void UpdateScreen(HDC dc, LPRECT rct);
	void DoConfigDialog(HWND wndParent);
	Circle* m_circles[MAX_CIRCLES];
};

SimpleSaver::SimpleSaver()
: m_rgb(RGB(0xf0, 0xf0, 0xf0))
{
}

void SimpleSaver::UpdateScreen(HDC dc, LPRECT rct)
{
	for(unsigned i=0; i < m_nNumCircles; i++)
	{
		m_circles[i]->Draw(dc, rct);
	}
}

BOOL SimpleSaver::Initialize(HINSTANCE hInst, int nCmdShow)
{
	if(!ScreenSaver::Initialize(hInst, nCmdShow))
		return FALSE;

	InitCommonControls();
	m_nCmdShow = nCmdShow;

	// ok, we should really use the Registry but
	// I'd rather contaminate win.ini with this sample
	m_rgb = GetProfileInt(kszAppSection, kszKeyCircleColor, RGB(0xf0, 0xf0, 0xf0));
	m_nNumCircles = min(MAX_CIRCLES, GetProfileInt(kszAppSection, kszKeyNumCircles, 3));
	for(unsigned i=0; i < m_nNumCircles; i++)
	{
		m_circles[i] = new Circle(m_rgb);
	}

	return TRUE;
}

BOOL SimpleSaver::Exitialize()
{
	for(unsigned i=0; i < m_nNumCircles; i++)
	{
		delete m_circles[i];
	}
	return TRUE;
}

LRESULT SimpleSaver::OnMessage(UINT message, WPARAM wParam, LPARAM lParam)
{
	return ScreenSaver::OnMessage(message, wParam, lParam);
}


BOOL CALLBACK ConfigDialogProc(
  HWND hwndDlg,
  UINT uMsg,
  WPARAM wParam,
  LPARAM lParam
)
{
	static SimpleSaver* pApp = NULL;
	CHOOSECOLOR cc;
	LPDRAWITEMSTRUCT lpdis;
	static COLORREF rgbCust[16] = {0};
	UINT bnFlags;
	static COLORREF rgbClr;
	static UINT nNumCircles;

    switch (uMsg) {
    case WM_INITDIALOG:
		pApp = (SimpleSaver*)lParam;
		if(pApp){
			rgbClr = pApp->m_rgb;
			nNumCircles = pApp->m_nNumCircles;
			SetDlgItemInt(hwndDlg, IDC_NUM_CIRCLES, nNumCircles, FALSE);
			return TRUE;
		}
		return FALSE;
	case WM_DRAWITEM: 
        lpdis = (LPDRAWITEMSTRUCT) lParam; 
		bnFlags = DFCS_BUTTONPUSH;
		if(lpdis->itemState & ODS_SELECTED)
			bnFlags |= DFCS_PUSHED;
		DrawFrameControl(lpdis->hDC, &(lpdis->rcItem), DFC_BUTTON, bnFlags);
		InflateRect(&(lpdis->rcItem), -2, -2);
		SetBkColor(lpdis->hDC, rgbClr);
		ExtTextOut(lpdis->hDC, 0, 0, ETO_OPAQUE, &(lpdis->rcItem), NULL, 0, NULL);
        return TRUE; 
    case WM_COMMAND:
		switch(wParam){
			case IDC_COLOR:
				cc.lStructSize = sizeof(cc);
				cc.hwndOwner = hwndDlg;
				cc.hInstance = NULL;
				cc.rgbResult = rgbClr;
				cc.lpCustColors = rgbCust;
				cc.Flags = CC_RGBINIT;
				cc.lCustData = NULL;
				cc.lpfnHook = NULL;
				cc.lpTemplateName = NULL;
				if(ChooseColor(&cc)){
					rgbClr = cc.rgbResult;
					InvalidateRect(hwndDlg, NULL, TRUE);
				}
				break;
			case IDOK:
				pApp->m_rgb = rgbClr;
				pApp->m_nNumCircles = GetDlgItemInt(hwndDlg, IDC_NUM_CIRCLES, NULL, FALSE);
				// fall through to ...
			case IDCANCEL:
				EndDialog(hwndDlg, wParam);
			break;
		}
	break;
    }
	return FALSE;
}

void SimpleSaver::DoConfigDialog(HWND wndParent)
{
	TCHAR szBuf[100];
	DialogBoxParam(m_hInst, MAKEINTRESOURCE(IDD_CONFIG), 
		wndParent, ConfigDialogProc, (LPARAM)this);
	sprintf(szBuf, "%d", (int)m_rgb);
	WriteProfileString(kszAppSection, kszKeyCircleColor, szBuf);
	sprintf(szBuf, "%d", (int)m_nNumCircles);
	WriteProfileString(kszAppSection, kszKeyNumCircles, szBuf);
}

/*
 *
 *	WinMain
 *	-------
 *	Entry point
 *
 */
int APIENTRY WinMain(HINSTANCE hInstance,
                     HINSTANCE hPrevInstance,
                     LPSTR     lpCmdLine,
                     int       nCmdShow)
{
	SimpleSaver theApp;
	if(!theApp.Initialize(hInstance, nCmdShow))
		return -1;
	theApp.Run(lpCmdLine);
	theApp.Exitialize();
	return 0;
}
