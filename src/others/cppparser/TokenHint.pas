unit TokenHint;

interface

uses
  Windows, Messages, Forms, Controls, Classes, Graphics, SysUtils, Types,
  TokenUtils, ImgList;

type
  TTokenHintBase = class(THintWindow)
  private
    FActivated: Boolean;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint; override;
    procedure ReleaseHandle;
  public
    procedure Cancel; virtual;
    procedure ActivateHint(Rect: TRect; const AHint: string); override;
    property Activated: Boolean read FActivated;
    constructor Create(AOwner: TComponent); override;
  end;

  TTokenHintParams = class(TTokenHintBase)
  private
    FIndex: Integer;
    FMaxCount: Integer;
    FItemIndex: Integer;
    FParams: TStrings;
    FBitmap: TBitmap;
    FDisabled: TBitmap;
    FMaskColor: TColor;
    procedure WMMouseActivate(var Message: TWMMouseActivate); message WM_MOUSEACTIVATE;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure SetBitmap(Value: TBitmap);
    procedure SetDisabledBitmap(Value: TBitmap);
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateHint(List: TStrings; Index, X, Y: Integer);
    property Bitmap: TBitmap read FBitmap write SetBitmap;
    property Disabled: TBitmap read FDisabled write SetDisabledBitmap;
    property MaskColor: TColor read FMaskColor write FMaskColor;
    property MaxCount: Integer read FMaxCount write FMaxCount;
  end;

  TTokenHintTip = class(TTokenHintBase)
  private
    FComments: TStrings;
    FImages: TCustomImageList;
    FImageIndex: Integer;
    procedure SetImages(const Value: TCustomImageList);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateHint(const S, Comment: string; X, Y, ImageIndex: Integer); virtual;
    property Images: TCustomImageList read FImages write SetImages;
  end;

implementation

uses Math;

procedure DrawTransparentBitmap(DC: HDC; hBmp: HBITMAP; xStart: integer;
  yStart, xOffSet, yOffSet, width, height: integer; cTransparentColor: COLORREF);
var
  bm: BITMAP;
  cColor: COLORREF;
  bmAndBack, bmAndObject, bmAndMem, bmSave: HBITMAP;
  bmBackOld, bmObjectOld, bmMemOld, bmSaveOld: HBITMAP;
  hdcMem, hdcBack, hdcObject, hdcTemp, hdcSave: HDC;
  ptSize: TPOINT;

begin
  hdcTemp := CreateCompatibleDC(dc);
  SelectObject(hdcTemp, hBmp); // Select the bitmap

  GetObject(hBmp, sizeof(BITMAP), @bm);
  ptSize.x := width; //bm.bmWidth;            // Get width of bitmap
  ptSize.y := height; //bm.bmHeight;          // Get height of bitmap
  DPtoLP(hdcTemp, ptSize, 1); // Convert from device
                                      // to logical points

  // Create some DCs to hold temporary data.
  hdcBack := CreateCompatibleDC(dc);
  hdcObject := CreateCompatibleDC(dc);
  hdcMem := CreateCompatibleDC(dc);
  hdcSave := CreateCompatibleDC(dc);

  // Create a bitmap for each DC. DCs are required for a number of
  // GDI functions.

  // Monochrome DC
  bmAndBack := CreateBitmap(ptSize.x, ptSize.y, 1, 1, nil);

  // Monochrome DC
  bmAndObject := CreateBitmap(ptSize.x, ptSize.y, 1, 1, nil);

  bmAndMem := CreateCompatibleBitmap(dc, ptSize.x, ptSize.y);
  bmSave := CreateCompatibleBitmap(dc, ptSize.x, ptSize.y);

  // Each DC must select a bitmap object to store pixel data.
  bmBackOld := SelectObject(hdcBack, bmAndBack);
  bmObjectOld := SelectObject(hdcObject, bmAndObject);
  bmMemOld := SelectObject(hdcMem, bmAndMem);
  bmSaveOld := SelectObject(hdcSave, bmSave);

  // Set proper mapping mode.
  SetMapMode(hdcTemp, GetMapMode(dc));

  // Save the bitmap sent here, because it will be overwritten.
  BitBlt(hdcSave, 0, 0, ptSize.x, ptSize.y, hdcTemp, xOffSet, yOffSet, SRCCOPY);

  // Set the background color of the source DC to the color.
  // contained in the parts of the bitmap that should be transparent
  cColor := SetBkColor(hdcTemp, cTransparentColor);

  // Create the object mask for the bitmap by performing a BitBlt
  // from the source bitmap to a monochrome bitmap.
  BitBlt(hdcObject, 0, 0, ptSize.x, ptSize.y, hdcTemp, xOffSet, yOffSet,
    SRCCOPY);

  // Set the background color of the source DC back to the original
  // color.
  SetBkColor(hdcTemp, cColor);

  // Create the inverse of the object mask.
  BitBlt(hdcBack, 0, 0, ptSize.x, ptSize.y, hdcObject, 0, 0,
    NOTSRCCOPY);

  // Copy the background of the main DC to the destination.
  BitBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, dc, xStart, yStart,
    SRCCOPY);

  // Mask out the places where the bitmap will be placed.
  BitBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, hdcObject, 0, 0, SRCAND);

  // Mask out the transparent colored pixels on the bitmap.
  BitBlt(hdcTemp, xOffSet, yOffSet, ptSize.x, ptSize.y, hdcBack, 0, 0, SRCAND);

  // XOR the bitmap with the background on the destination DC.
  BitBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, hdcTemp, xOffSet, yOffSet, SRCPAINT);

  // Copy the destination to the screen.
  BitBlt(dc, xStart, yStart, ptSize.x, ptSize.y, hdcMem, 0, 0, SRCCOPY);

  // Place the original bitmap back into the bitmap sent here.
  BitBlt(hdcTemp, xOffSet, yOffSet, ptSize.x, ptSize.y, hdcSave, 0, 0, SRCCOPY);

  // Delete the memory bitmaps.
  DeleteObject(SelectObject(hdcBack, bmBackOld));
  DeleteObject(SelectObject(hdcObject, bmObjectOld));
  DeleteObject(SelectObject(hdcMem, bmMemOld));
  DeleteObject(SelectObject(hdcSave, bmSaveOld));

  // Delete the memory DCs.
  DeleteDC(hdcMem);
  DeleteDC(hdcBack);
  DeleteDC(hdcObject);
  DeleteDC(hdcSave);
  DeleteDC(hdcTemp);
end;

function ConvertBitmapToGrayscale(const src: TBitmap;
  ColorMask: Cardinal): TBitmap;
var
  Bitmap: TBitmap;
  i, j: Integer;
  Grayshade, Red, Green, Blue: Byte;
  PixelColor: Longint;
begin
  Bitmap := TBitmap.Create;
  Bitmap.Width := src.Width;
  Bitmap.Height := src.Height;
  Bitmap.Canvas.Draw(0, 0, src);
  with Bitmap do
    for i := 0 to Width - 1 do
      for j := 0 to Height - 1 do
      begin
        PixelColor := ColorToRGB(Canvas.Pixels[i, j]);
        Red := PixelColor;
        Green := PixelColor shr 8;
        Blue := PixelColor shr 16;
        Grayshade := Round(0.3 * Red + 0.6 * Green + 0.1 * Blue) + 127;
        if RGB(Red, Green, Blue) <> ColorMask then
          Canvas.Pixels[i, j] := RGB(Grayshade, Grayshade, Grayshade);
      end;
  Result := Bitmap;
end;

constructor TTokenHintBase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Font.Color := Screen.HintFont.Color;
  Color := $E1FFFF;
end;

procedure TTokenHintBase.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params do
  begin
    Style := WS_POPUP or WS_BORDER;
    WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
    if NewStyleControls then
      ExStyle := WS_EX_TOOLWINDOW;
    //if NewStyleControls then
    //  ExStyle := WS_EX_WINDOWEDGE; appear in task bar
    AddBiDiModeExStyle(ExStyle);
  end;
end;

procedure TTokenHintBase.ActivateHint(Rect: TRect; const AHint: string);
begin
  inherited;
  if not FActivated then
    Show;
  FActivated := True;
end;

procedure TTokenHintBase.Cancel;
begin
  if not FActivated then
    Exit;
  FActivated := False;
  Hide;
end;

procedure TTokenHintBase.ReleaseHandle;
begin
  FActivated := False;
  DestroyHandle;
end;

procedure TTokenHintBase.Paint;
var
  R: TRect;
begin
  R := ClientRect;
  Inc(R.Left, 2);
  Inc(R.Top, 2);
  Canvas.Font.Color := Font.Color;
  DrawText(Canvas.Handle, PChar(Caption), -1, R, DT_LEFT or DT_NOPREFIX or
    DT_WORDBREAK or DrawTextBiDiModeFlagsReadingOnly);
end;

{TTokenHintParams}

constructor TTokenHintParams.Create(AOwner: TComponent);
const
  BmpArrowUp: array[0..3] of TPoint = (
    (X: 2; Y: 6; ),
    (X: 7; Y: 11),
    (X: 8; Y: 11),
    (X: 13; Y: 6));
  BmpArrowDown: array[0..3] of TPoint = (
    (X: 23; Y: 6; ),
    (X: 24; Y: 6),
    (X: 29; Y: 11),
    (X: 18; Y: 11));
begin
  inherited Create(AOwner);
  FItemIndex := 0;
  FMaskColor := clFuchsia;
  FMaxCount := 3;
  FParams := TStringList.Create;
  FBitmap := TBitmap.Create;
  FBitmap.Width := 32;
  FBitmap.Height := 16;
  FBitmap.Canvas.Brush.Color := FMaskColor;
  FBitmap.Canvas.FillRect(FBitmap.Canvas.ClipRect);
  FBitmap.Canvas.Brush.Color := clBlack;
  FBitmap.Canvas.Polygon(BmpArrowUp);
  FBitmap.Canvas.Polygon(BmpArrowDown);
  FDisabled := ConvertBitmapToGrayscale(FBitmap, FMaskColor);
  SetClassLong(Handle, GCL_STYLE, GetClassLong(Handle, GCL_STYLE) and not CS_DROPSHADOW);
end;

destructor TTokenHintParams.Destroy;
begin
  FParams.Free;
  FBitmap.Free;
  FDisabled.Free;
  inherited Destroy;
end;

procedure TTokenHintParams.CreateParams(var Params: TCreateParams);
begin
  inherited;
end;

procedure TTokenHintParams.SetBitmap(Value: TBitmap);
begin
  if Assigned(Value) and (Value.Height = 16) and (Value.Width = 32) then
  begin
    FBitmap.Assign(Value);
    FDisabled.Free;
    FDisabled := ConvertBitmapToGrayscale(FBitmap, FMaskColor);
  end;
end;

procedure TTokenHintParams.SetDisabledBitmap(Value: TBitmap);
begin
  if Assigned(Value) and (Value.Height = 16) and (Value.Width = 32) then
  begin
    FDisabled.Assign(Value);
  end;
end;

procedure TTokenHintParams.Paint;
var
  S, S1, S2, S3: string;
  R: TRect;
  I, hintHeight, cLeft, TempIndex: Integer;
  penColor: TColor;
begin
  inherited;
  R := ClientRect;
  Inc(R.Left, 2);
  Inc(R.Top, 1);
  cLeft := R.Left;
  for I := 0 to FParams.Count - 1 do
  begin
    TempIndex := I;
    if FParams.Count > FMaxCount then
      TempIndex := FItemIndex;
    S := FParams.Strings[TempIndex];
    hintHeight := Canvas.TextHeight(S);
    R.Bottom := R.Top + hintHeight;
    //**********
    S1 := GetParamsBefore(S, FIndex);
    DrawText(Canvas.Handle, PChar(S1), -1, R, DT_LEFT or DT_NOPREFIX or
      DT_WORDBREAK or DrawTextBiDiModeFlagsReadingOnly);

    R.Left := R.Left + Canvas.TextWidth(S1);
    Canvas.Font.Style := Canvas.Font.Style + [fsBold];
    S2 := GetActiveParams(S, FIndex);
    DrawText(Canvas.Handle, PChar(S2), -1, R, DT_LEFT or DT_NOPREFIX or
      DT_WORDBREAK or DrawTextBiDiModeFlagsReadingOnly);

    R.Left := R.Left + Canvas.TextWidth(S2);
    Canvas.Font.Style := Canvas.Font.Style - [fsBold];
    S3 := GetParamsAfter(S, FIndex);
    DrawText(Canvas.Handle, PChar(S3), -1, R, DT_LEFT or DT_NOPREFIX or
      DT_WORDBREAK or DrawTextBiDiModeFlagsReadingOnly);

    //draw button
    if FParams.Count > MaxCount then
    begin
      if FItemIndex < FParams.Count - 1 then
        DrawTransparentBitmap(Canvas.Handle, FBitmap.Handle,
          R.Right - FBitmap.Width - 2, R.Top - 1, 0, 0, FBitmap.Width div 2,
          FBitmap.Height, FMaskColor)
      else
        DrawTransparentBitmap(Canvas.Handle, FDisabled.Handle,
          R.Right - FDisabled.Width - 2, R.Top - 1, 0, 0, FDisabled.Width div 2,
          FDisabled.Height, FMaskColor);
      if FItemIndex > 0 then
        DrawTransparentBitmap(Canvas.Handle, FBitmap.Handle,
          R.Right - 2 - (FBitmap.Width div 2), R.Top - 1,
          FBitmap.Width div 2, 0, FBitmap.Width div 2, FBitmap.Height,
          FMaskColor)
      else
        DrawTransparentBitmap(Canvas.Handle, FDisabled.Handle,
          R.Right - 2 - (FDisabled.Width div 2), R.Top - 1,
          FDisabled.Width div 2, 0, FDisabled.Width div 2, FDisabled.Height,
          FMaskColor);
    end;
    //*********
    Inc(R.Top, hintHeight);
    Inc(R.Top, 3);
    R.Left := 0;
    penColor := Canvas.Pen.Color;
    Canvas.Pen.Color := clBtnShadow;
    Canvas.MoveTo(R.Left, R.Top);
    Canvas.LineTo(R.Right, R.Top);
    Canvas.Pen.Color := penColor;
    if FParams.Count > FMaxCount then
      Break;
    Inc(R.Top, 2);
    R.Left := cLeft;
  end;
end;

procedure TTokenHintParams.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  R: TRect;
  P: TPoint;
begin
  if (FParams.Count <= FMaxCount) or (FParams.Count = 1) then
    Exit;
  R := ClientRect;
  R.Left := R.Right - FBitmap.Width - 2;
  R.Right := R.Left + (FBitmap.Width div 2);
  P.X := X;
  P.Y := Y;
  //button down
  if PtInRect(R, P) then
  begin
    if FItemIndex >= FParams.Count - 1 then
      Exit;
    Inc(FItemIndex);
    Invalidate;
    Exit;
  end;

  Inc(R.Left, (FBitmap.Width div 2));
  R.Right := R.Left + (FBitmap.Width div 2);
  //button up
  if PtInRect(R, P) then
  begin
    if FItemIndex <= 0 then
      Exit;
    Dec(FItemIndex);
    Invalidate;
    Exit;
  end;
end;

procedure TTokenHintParams.WMMouseActivate(var Message: TWMMouseActivate);
begin
  Message.Result := MA_NOACTIVATE;
end;

procedure TTokenHintParams.UpdateHint(List: TStrings; Index, X, Y: Integer);
var
  R: TRect;
  CalcDist: Integer;
  CanInv: Boolean;
  I: Integer;
  hintWidth, hintHeight: Integer;
begin
  CanInv := True;
  FParams.Assign(List);
  if FItemIndex >= FParams.Count then
    FItemIndex := FParams.Count - 1;
  CalcDist := 30;
  hintWidth := 0;
  hintHeight := 2; //border, include bottom line
  for I := 0 to FParams.Count - 1 do
  begin
    hintWidth := Max(Canvas.TextWidth(FParams.Strings[I]), hintWidth);
    if ((FParams.Count > FMaxCount) and (FItemIndex = I)) or
      (FParams.Count <= FMaxCount) then
      Inc(hintHeight, Canvas.TextHeight(FParams.Strings[I]) + 5);
  end;
  if (FParams.Count > FMaxCount) and (FParams.Count > 1) then
    Inc(hintWidth, FBitmap.Width + 4); //updown list
  Dec(hintHeight, 1); //last line
  Dec(Y, hintHeight);
  R := Rect(X, Y, hintWidth + X + CalcDist, Y + hintHeight);
  FIndex := Index;
  if FActivated then
  begin
    UpdateBoundsRect(R);
    if R.Top + Height > Screen.DesktopHeight then
      R.Top := Screen.DesktopHeight - Height;
    if R.Left + Width > Screen.DesktopWidth then
      R.Left := Screen.DesktopWidth - Width;
    if R.Left < Screen.DesktopLeft then
      R.Left := Screen.DesktopLeft;
    if R.Bottom < Screen.DesktopTop then
      R.Bottom := Screen.DesktopTop;
    SetWindowPos(Handle, HWND_TOPMOST, R.Left, R.Top, Width, Height,
      SWP_NOACTIVATE);
    Show;
  end
  else
  begin
    Dec(R.Bottom, 4);
    UpdateBoundsRect(R);
    ActivateHint(R, '');
  end;
  if CanInv then
    Invalidate;
end;

procedure TTokenHintParams.WMNCHitTest(var Message: TWMNCHitTest);
begin
  Message.Result := HTCLIENT;
end;

{TTokenHintTip}

constructor TTokenHintTip.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FComments := TStringList.Create;
  FImageIndex := -1;
end;

destructor TTokenHintTip.Destroy;
begin
  FComments.Free;
  inherited;
end;

procedure TTokenHintTip.Paint;
var
  R: TRect;
  I, SaveLeft: Integer;
  S: string;
begin
  R := ClientRect;
  Inc(R.Left, 2);
  SaveLeft := R.Left;
  Inc(R.Top, 2);
  Canvas.Font.Color := Font.Color;
  if (Images <> nil) and (FImageIndex >= 0) then
  begin
    Images.Draw(Canvas, R.Left, R.Top + (Canvas.TextHeight(Caption) - Images.Height) div 2, FImageIndex);
    Inc(R.Left, Images.Width + 2);
  end;
  DrawText(Canvas.Handle, PChar(Caption), -1, R, DT_LEFT or DT_NOPREFIX or
    DT_WORDBREAK or DrawTextBiDiModeFlagsReadingOnly);
  R.Left := SaveLeft;
  Inc(R.Top, Canvas.TextHeight(Caption) + 10);
  for I := 0 to FComments.Count - 1 do
  begin
    S := FComments.Strings[I];
    R.Bottom := R.Top + Canvas.TextHeight(S);
    DrawText(Canvas.Handle, PChar(S), -1, R, DT_LEFT or DT_NOPREFIX or
      DT_WORDBREAK or DrawTextBiDiModeFlagsReadingOnly);
    Inc(R.Top, Canvas.TextHeight(S) + 2);
  end;
end;

procedure TTokenHintTip.SetImages(const Value: TCustomImageList);
begin
  if Value = FImages then
    Exit;
  FImages := Value;
end;

procedure TTokenHintTip.UpdateHint(const S, Comment: string; X, Y, ImageIndex: Integer);
var
  R: TRect;
  CommentHeight, I: Integer;
begin
  FComments.Text := Comment;
  FImageIndex := ImageIndex;
  if Comment = '' then
    FComments.Clear;
  R := Rect(X, Y, Canvas.TextWidth(S) + X + 10, Canvas.TextHeight(S) + Y + 2);
  if (Images <> nil) and (ImageIndex >= 0) then
    Inc(R.Right, Images.Width + 2);
  if FComments.Count > 0 then
    CommentHeight := 8
  else
    CommentHeight := 0;
  for I := 0 to FComments.Count - 1 do
  begin
    R.Right := Max(R.Right, X + Canvas.TextWidth(FComments.Strings[I]) + 10);
    Inc(CommentHeight, Canvas.TextHeight(FComments.Strings[I]) + 2);
  end;
  Inc(R.Bottom, CommentHeight);
  if FActivated then
  begin
    Caption := S;
    Inc(R.Bottom, 4);
    UpdateBoundsRect(R);
    if R.Top + Height > Screen.DesktopHeight then
      R.Top := Screen.DesktopHeight - Height;
    if R.Left + Width > Screen.DesktopWidth then
      R.Left := Screen.DesktopWidth - Width;
    if R.Left < Screen.DesktopLeft then
      R.Left := Screen.DesktopLeft;
    if R.Bottom < Screen.DesktopTop then
      R.Bottom := Screen.DesktopTop;
    SetWindowPos(Handle, HWND_TOPMOST, R.Left, R.Top, Width, Height,
      SWP_NOACTIVATE);
  end
  else
    ActivateHint(R, S);
end;

end.

