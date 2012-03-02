unit HintTree;

interface

uses
  Windows, Messages, Classes, Forms, Controls, Graphics, SysUtils, ComCtrls,
  ExtCtrls, TokenList, TokenHint, StdCtrls, DebugReader, DebugWatch;

type
  THintTreeTip = class(TTokenHintTip);
  THintTree = class(TCustomControl)
  private
    TreeView: TTreeView;
    DebugParser: TDebugParser;
    FFocusDelay: Integer;
    fptr: PChar;
    FValue: String;
    FActivated: Boolean;
    FWindowMode: Boolean;
    FLastActive: Cardinal;
    TreeViewOldProc: TWndMethod;
    Timer: TTimer;
    procedure TreeViewProc(var Msg: TMessage);
    procedure WMMouseActivate(var Message: TWMMouseActivate); message WM_MOUSEACTIVATE;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure ActivateHint(Rect: TRect);
    procedure SetImageList(Value: TImageList);
    procedure TreeViewKeyPress(Sender: TObject; var Key: Char);
    procedure HintMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure TimerEvent(Sender: TObject);
    procedure UpdateStyle;
    function GetClickable: Boolean;
    procedure SetFocusDelay(Value: Integer);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    procedure AdjustHintRect(Rect: TRect);
    property Activated: Boolean read FActivated;
    property WindowMode: Boolean read FWindowMode;
    property FocusDelay: Integer read FFocusDelay write SetFocusDelay;
    property Clickable: Boolean read GetClickable;
    property ImageList: TImageList write SetImageList;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateHint(const S: String; X, Y: Integer; Token: TTokenClass);
    procedure Cancel;
  end;

implementation

uses Types, TokenFile, TokenUtils;

constructor THintTree.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DebugParser := TDebugParser.Create;
  Color := $E1FFFF;
  Canvas.Font := Screen.HintFont;
  Canvas.Brush.Style := bsClear;
  TreeView := TTreeView.Create(Self);
  DebugParser.TreeView := TreeView;
  TreeView.Parent := Self;
  //TreeView.AutoExpand := True;
  TreeView.BorderStyle := bsNone;
  TreeView.Align := alClient;
  TreeView.Color := $E1FFFF;
  TreeView.ReadOnly := True;
  TreeView.OnKeyPress := TreeViewKeyPress;
  TreeView.OnMouseMove := HintMouseMove;
  OnMouseMove := HintMouseMove;
  TreeViewOldProc := TreeView.WindowProc;
  TreeView.WindowProc := TreeViewProc;
  TreeView.DoubleBuffered := True;
  Timer := TTimer.Create(nil);
  Timer.Enabled := False;
  FocusDelay := 500;
  Timer.OnTimer := TimerEvent;
end;

destructor THintTree.Destroy;
begin
  DebugParser.Free;
  Timer.Free;
  inherited Destroy;
end;

procedure THintTree.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params do
  begin
    Style := WS_POPUP or WS_BORDER;
    WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
    if NewStyleControls then
      ExStyle := WS_EX_TOOLWINDOW;
    // CS_DROPSHADOW requires Windows XP or above
    if CheckWin32Version(5, 1) then
      WindowClass.style := WindowClass.style or CS_DROPSHADOW;
    AddBiDiModeExStyle(ExStyle);
  end;
end;

procedure THintTree.UpdateStyle;
var
  Style: Cardinal;
begin
  Style := GetWindowLong(Handle, GWL_STYLE);
  if FWindowMode then
    Style := (Style or WS_THICKFRAME) and not WS_BORDER
  else
    Style := (Style or WS_BORDER) and not WS_THICKFRAME;
  SetWindowLong(Handle, GWL_STYLE, Style);
  Update;
end;

procedure THintTree.CMMouseEnter(var Message: TMessage);
begin
  if not FWindowMode and GetClickable then
  begin
    Timer.Enabled := False;
    Timer.Enabled := True;
  end;
end;

procedure THintTree.HintMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if not FWindowMode and GetClickable then
  begin
    Timer.Enabled := False;
    Timer.Enabled := True;
  end;
end;

procedure THintTree.CMMouseLeave(var Message: TMessage);
begin
  if not FWindowMode and GetClickable then
    Timer.Enabled := False;
end;

procedure THintTree.TreeViewProc(var Msg: TMessage);
begin
  if (Msg.Msg = WM_NCHITTEST) and (not GetClickable or not WindowMode) then
    Msg.Result := HTTRANSPARENT
  else if (Msg.Msg <> WM_RBUTTONDOWN) and (Msg.Msg <> WM_RBUTTONUP) then
    TreeViewOldProc(Msg);
end;

procedure THintTree.WMMouseActivate(var Message: TWMMouseActivate);
begin
  Message.Result := MA_NOACTIVATE;
end;

procedure THintTree.WMNCHitTest(var Message: TWMNCHitTest);
begin
  inherited;
  if not GetClickable then
    Message.Result := HTTRANSPARENT;
end;

procedure THintTree.SetImageList(Value: TImageList);
begin
  TreeView.Images := Value;
end;

procedure THintTree.Cancel;
begin
  FActivated := False;
  if FWindowMode then
  begin
    FWindowMode := False;
    UpdateStyle;
  end;
  ShowWindow(Handle, SW_HIDE);
  //Hide;
end;

procedure THintTree.AdjustHintRect(Rect: TRect);
begin
  Inc(Rect.Bottom, 4);
  UpdateBoundsRect(Rect);
  if Rect.Top + Height > Screen.DesktopHeight then
    Rect.Top := Screen.DesktopHeight - Height;
  if Rect.Left + Width > Screen.DesktopWidth then
    Rect.Left := Screen.DesktopWidth - Width;
  if Rect.Left < Screen.DesktopLeft then Rect.Left := Screen.DesktopLeft;
  if Rect.Bottom < Screen.DesktopTop then Rect.Bottom := Screen.DesktopTop;
  SetWindowPos(Handle, HWND_TOPMOST, Rect.Left, Rect.Top, Width, Height,
    SWP_NOACTIVATE);
end;

procedure THintTree.ActivateHint(Rect: TRect);
type
  TAnimationStyle = (atSlideNeg, atSlidePos, atBlend);
const
  AnimationStyle: array[TAnimationStyle] of Integer = (AW_VER_NEGATIVE,
    AW_VER_POSITIVE, AW_BLEND);
var
  Animate: BOOL;
  Style: TAnimationStyle;
begin
  try
    //AdjustHintRect(Rect);
    if (GetTickCount - FLastActive > 250) and Assigned(AnimateWindowProc) then
    begin
      SystemParametersInfo(SPI_GETTOOLTIPANIMATION, 0, @Animate, 0);
      if Animate then
      begin
        SystemParametersInfo(SPI_GETTOOLTIPFADE, 0, @Animate, 0);
        if Animate then
          Style := atBlend
        else
          if Mouse.CursorPos.Y > Rect.Top then
            Style := atSlideNeg
          else
            Style := atSlidePos;
        AnimateWindowProc(Handle, 100, AnimationStyle[Style] or AW_SLIDE);
      end;
    end;
    ParentWindow := Application.Handle;
    ShowWindow(Handle, SW_SHOWNOACTIVATE);
//    Invalidate;
  finally
    FLastActive := GetTickCount;
  end;
//  if not FActivated then
//    Show;
  FActivated := True;
end;

procedure THintTree.UpdateHint(const S: String; X, Y: Integer;
  Token: TTokenClass);
var
  R, ItemRect: TRect;
  newWidth, newHeight, I, MultIdent: Integer;
  Item: TTreeNode;
begin
  if S <> FValue then
  begin
    FValue := S;
    TreeView.Items.Clear;
    fptr := PChar(FValue);
    DebugParser.Clear;
    DebugParser.Fill(FValue, Token);
  end;
  if FWindowMode then
  begin
    FWindowMode := False;
    UpdateStyle;
  end;
  Item := TreeView.Items.GetFirstNode;
  if Assigned(Item) then
  begin
    ItemRect := Item.DisplayRect(False);
    newWidth := Canvas.TextWidth(Item.Text);
    MultIdent := 1;
    for I := 0 to Item.Count - 1 do
    begin
      MultIdent := 2;
      if Canvas.TextWidth(Item.Item[I].Text) > newWidth then
        newWidth := Canvas.TextWidth(Item.Item[I].Text);
    end;
    Inc(newWidth, (TreeView.Indent + TreeView.Images.Width) * MultIdent + 20);
    newHeight := (Item.Count + 1) * (ItemRect.Bottom - ItemRect.Top) + 1;
    R := Rect(X, Y, X + newWidth, Y + newHeight);
    TreeView.ShowRoot := TreeView.Items.Count > 1;
  end
  else
    Exit;
  AdjustHintRect(R);
  Item.Expanded := True;
  if not Activated then
    ActivateHint(R);
end;

procedure THintTree.TreeViewKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    Cancel
  end;
end;

function THintTree.GetClickable: Boolean;
begin
  Result := FActivated and (TreeView.Items.Count > 1);
end;

procedure THintTree.SetFocusDelay(Value: Integer);
begin
  if (Value <> FFocusDelay) then
  begin
    FFocusDelay := Value;
    Timer.Interval := FFocusDelay;
  end;
end;

procedure THintTree.TimerEvent(Sender: TObject);
var
  R: TRect;
  DiffX, DiffY, SingleBorderX, SingleBorderY, newWidth, newHeight: Integer;
begin
  Timer.Enabled := False;
  if not FWindowMode and GetClickable then
  begin
    R.Left := 0;
    R.Top := 0;
    R.Right := ClientWidth;
    SingleBorderX := Width - ClientWidth;
    R.Bottom := ClientHeight;
    SingleBorderY := Height - ClientHeight;
    AdjustWindowRectEx(R, WS_POPUP or WS_THICKFRAME, FALSE, WS_EX_TOOLWINDOW);
    FWindowMode := True;
    UpdateStyle;
    //Border Size
    newWidth := R.Right - R.Left;
    DiffX := (newWidth - ClientWidth) - SingleBorderX;
    newHeight := R.Bottom - R.Top;
    DiffY := (newHeight - ClientHeight) - SingleBorderY;
                     //Left border pixels
    R.Left := Left - (DiffX div 2);
                   //Top border pixels
    R.Top := Top - (DiffY div 2);
    R.Right := R.Left + newWidth; //AdjustHintRect increment 4 for bottom
    R.Bottom := R.Top + newHeight - 4;
    AdjustHintRect(R);
  end;
end;

end.
