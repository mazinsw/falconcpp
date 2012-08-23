unit NativeHintWindow;

(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * Contributor(s):
 *   Xu, Qian <http://stanleyxu2005.blogspot.com/>
 *
 * ***** END LICENSE BLOCK ***** *)

 {
    Known Limition(s):

     1. Once THintWindow is replaced with THintWindowFix, the procedure
        TApplication.HideHint() must be patched as well. However, after
        patching the original method pointer will be discarded, which
        means, that it is impossible to revert to THintWindow again.

     2. TApplication.ActivateHint() doesn't work with THintWindowFix
        properly. Please use ApplicationActivateHint() instead.
        To note, that I have tried to patch TApplication.ActivateHint(),
        but not tooltip can be shown any more. I will be appreciated,
        if you can help me to fix this issue ^^)

     3. Unicode support. If your project is based on TntControls, please
        include the unit TntNativeHintWindow instead of NativeHintWindow.
        Hint text is internall encoded as UTF8.
 }

interface

uses
  Classes, Controls, Windows, Messages;

const
  TTM_ADJUSTRECT = WM_USER + 31;
type
  THintWindowFix = class(THintWindow)
  private
    OldAppHintHandler: TNotifyEvent;
    function NativeActivateHintEx(PopupPoint: TPoint; const HintText: string): THandle;
  protected
    procedure AppHintHandler(Sender: TObject);
  // BLOCK-BEGIN: Disable the following procedures.
  private
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint; override;
    procedure NCPaint(DC: HDC); override;
    procedure WMPrint(var Message: TMessage); message WM_PRINT;
  // BLOCK-END
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReleaseHandle;
    procedure ActivateHint(Rect: TRect; const AHint: string); override;
    function CalcHintRect(MaxWidth: Integer; const AHint: string; AData: Pointer): TRect; override;
  end;

// A replacement of TApplication.ActivateHint() when HintWindowClass=THintWindowFix.
procedure ApplicationActivateHint(CursorPos: TPoint);
// Applies the patch of HintWindowClass.
procedure PatchHintWindowClass;

var
  AutoPatchOnStartup: Boolean = True;

implementation

uses
  CommCtrl, Forms, SysUtils,
  FastcodePatch {http://fastcode.sourceforge.net/};

{ Utils }

function MeasureSingleLineString(const S: string): TSize;
var
  DC: HDC;
  hOldFont: HFONT;
begin
  FillChar(Result, SizeOf(Result), #0);
  DC := GetDC(0);
  try
    hOldFont := SelectObject(DC, Screen.HintFont.Handle);
    if not GetTextExtentPoint32(DC, PChar(S), Length(S), Result) then
    begin
      Result.cx := 0;
      Result.cy := 0;
    end;
    SelectObject(DC, hOldFont);
  finally
    ReleaseDC(0, DC);
  end;
end;

function MeasureString(S: string; LineMargin: Integer = 0): TSize;
const
  cLengthOfLineBreak = Length(sLineBreak);
var
  P: Integer;
  Dim: TSize;
begin
  Result.cx := 0;
  Result.cy := 0;

  P := Pos(sLineBreak, S);
  while P > 0 do
  begin
    Dim := MeasureSingleLineString(Copy(S, 1, P - 1));
    if Result.cx < Dim.cx then
      Result.cx := Dim.cx;
    Inc(Result.cy, Dim.cy + LineMargin);
    Delete(S, 1, P + cLengthOfLineBreak - 1);
    P := Pos(sLineBreak, S);
  end;
  Dim := MeasureSingleLineString(S);
  if Result.cx < Dim.cx then
    Result.cx := Dim.cx;
  Inc(Result.cy, Dim.cy);
end;

{ THintWindowFix }

var
  HintWindowInstances: TList;

function THintWindowFix.NativeActivateHintEx(PopupPoint: TPoint; const HintText: string): THandle;
var
  MousePos, HintWinDim: TPoint;
  Mon: TMonitor;
  MonRect, TmpRect: TRect;
  TI: TOOLINFO;
  hControl: THandle;
begin
  Result := CreateWindow(TOOLTIPS_CLASS, nil, WS_POPUP or TTS_NOPREFIX or TTS_ALWAYSTIP,
    Integer(CW_USEDEFAULT), Integer(CW_USEDEFAULT), Integer(CW_USEDEFAULT), Integer(CW_USEDEFAULT),
    0, 0, HInstance, nil);
  if Result <> 0 then
  begin
    SetWindowPos(Result, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
    // Retrieves handle before PopupPoint is changed.
    hControl := WindowFromPoint(PopupPoint);

    // Calculates the rect of the hint window.
    Mon := Screen.MonitorFromPoint(PopupPoint);
    if Mon <> nil then
      MonRect := Mon.BoundsRect
    else
      MonRect := Screen.DesktopRect;
    with CalcHintRect(MonRect.Right - MonRect.Left, HintText, nil) do
    begin
      HintWinDim.X := Right - Left;
      HintWinDim.Y := Bottom - Top;
    end;
    FillChar(TmpRect, SizeOf(TmpRect), #0);
    SendMessage(Result, TTM_ADJUSTRECT {WM_USER+31}, 1, WPARAM(@TmpRect));
    Inc(HintWinDim.X, (TmpRect.Right - TmpRect.Left) * 2);
    Inc(HintWinDim.Y, (TmpRect.Bottom - TmpRect.Top) * 2);
    // Corrects the position of the hint window, when it is partial out of the screen.
    if PopupPoint.Y + HintWinDim.Y >= MonRect.Bottom then
    begin
      GetCursorPos(MousePos);
      PopupPoint.Y := MousePos.Y - HintWinDim.Y;
    end;
    if PopupPoint.X + HintWinDim.X >= MonRect.Right then
      PopupPoint.X := MonRect.Right - HintWinDim.X;
    if PopupPoint.X < MonRect.Left then
      PopupPoint.X := MonRect.Left;
    if PopupPoint.Y < MonRect.Top then
      PopupPoint.Y := MonRect.Top;

    // Enables multi-line hint (delimeter #13#10)
    SendMessage(Result, TTM_SETMAXTIPWIDTH, 0, MonRect.Right - MonRect.Left);
    // Specifies the text font style
    //SendMessage(Result, WM_SETFONT, Screen.HintFont.Handle, Integer(LongBool(False)))

    FillChar(TI, SizeOf(TI), #0);
    TI.cbSize := SizeOf(TI);
    TI.hwnd := hControl;
    TI.lpszText := PChar(HintText);
    TI.uFlags := TTF_TRANSPARENT or TTF_SUBCLASS or TTF_TRACK or TTF_ABSOLUTE;
    SendMessage(Result, TTM_ADDTOOL, 0, Integer(@TI));
    SendMessage(Result, TTM_TRACKPOSITION, 0, MAKELPARAM(PopupPoint.X, PopupPoint.Y + 1));
    SendMessage(Result, TTM_TRACKACTIVATE, Integer(LongBool(True)), Integer(@TI));
  end;
end;

constructor THintWindowFix.Create(AOwner: TComponent);
begin
  inherited;
  OldAppHintHandler := Application.OnHint;
  Application.OnHint := AppHintHandler;
  // http://msdn2.microsoft.com/en-us/library/aa511495.aspx
  Application.HintPause := GetDoubleClickTime();
  Application.HintShortPause := GetDoubleClickTime() div 5;
  Application.HintHidePause := GetDoubleClickTime() * 10;

  // Adds to global instance register
  HintWindowInstances.Add(Self);
end;

destructor THintWindowFix.Destroy;
begin
  // Removes from global instance register
  HintWindowInstances.Remove(Self);

  Application.OnHint := OldAppHintHandler;
  inherited;
end;

procedure THintWindowFix.CreateParams(var Params: TCreateParams);
begin
  //Do nothing
end;

procedure THintWindowFix.WMNCPaint(var Message: TMessage);
begin
  //Do nothing
end;

procedure THintWindowFix.Paint;
begin
  //Do nothing
end;

procedure THintWindowFix.CMTextChanged(var Message: TMessage);
begin
  //Do nothing
end;

procedure THintWindowFix.NCPaint(DC: HDC);
begin
  //Do nothing
end;

procedure THintWindowFix.WMPrint(var Message: TMessage);
begin
  //Do nothing
end;

procedure THintWindowFix.AppHintHandler(Sender: TObject);
begin
  if Trim(GetShortHint(Application.Hint)) = '' then
  begin
    ReleaseHandle;
  end;
end;

type
  THintWindowHack = class(THintWindow) // CAUTION: Please check the declaration
  private //          of Controls.THintWindow
    FActivating: Boolean;
    FLastActive: Cardinal;
  end;

procedure THintWindowFix.ReleaseHandle;
begin
  with THintWindowHack(Self) do
    if IsWindow(FLastActive) then
      DestroyWindow(FLastActive);
end;

procedure THintWindowFix.ActivateHint(Rect: TRect; const AHint: string);
begin
  with THintWindowHack(Self) do
  begin
    if IsWindow(FLastActive) then // Copied from ReleaseHandle()
    begin
      if AHint = Caption then
        Exit // To avoid the hint to be be drawn multiple times
      else
        DestroyWindow(FLastActive); // Copied from ReleaseHandle()
    end;

    FActivating := True;
    try
      Caption := AHint;
      FLastActive := NativeActivateHintEx(Rect.TopLeft, AHint);
    finally
      FActivating := False;
    end;
  end;
end;

function THintWindowFix.CalcHintRect(MaxWidth: Integer; const AHint: string; AData: Pointer): TRect;
begin
  //NOTE: Canvas is invalid in THintWindowFix.

  with MeasureString(AHint) do
    Result := Rect(0, 0, cx, cy);
end;

// A replacement of TApplication.ActivateHint() when HintWindowClass=THintWindowFix.

procedure ApplicationActivateHint(CursorPos: TPoint);
begin
  if Application.ShowHint then
  begin
    if HintWindowInstances.Count = 0 then
    begin
      //NOTE: Forces Application to create an instance of its HintWindowClass.
      Application.ShowHint := False;
      Application.ShowHint := True;
    end;
    if HintWindowInstances.Count > 0 then
      THintWindowFix(HintWindowInstances.Items[0]).ActivateHint(
        Rect(CursorPos.X, CursorPos.Y, 0, 0), Application.Hint);
  end;
end;

{ RTL patch }

procedure TApplicationHideHintStub;
asm
  call TApplication.HideHint;
end;

type
  TApplicationPatch = class(TApplication)
  public
    procedure HideHint;
    //NOTE: Failed to patch procedure ActivateHint(CursorPos: TPoint);
  end;

procedure TApplicationPatch.HideHint;
begin
  if HintWindowInstances.Count > 0 then
    THintWindowFix(HintWindowInstances.Items[0]).ReleaseHandle;
end;

// Applies the patch of HintWindowClass.

procedure PatchHintWindowClass;
begin
  HintWindowClass := THintWindowFix;
  // This cannot be undone
  FastcodeAddressPatch(
    FastcodeGetAddress(@TApplicationHideHintStub),
    @TApplicationPatch.HideHint);
end;

initialization
  HintWindowInstances := TList.Create;

  if AutoPatchOnStartup then
    PatchHintWindowClass;

finalization
  HintWindowInstances.Free;

end.
