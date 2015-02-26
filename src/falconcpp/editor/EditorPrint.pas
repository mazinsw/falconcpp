unit EditorPrint;

interface

uses
  Windows, Classes, UEditor, Dialogs, Printers, DScintillaTypes;

type
  TEditorPrint = class(TComponent)
  private
    FDocTitle: string;
    FEditor: TEditor;
    FPrintDialog: TPrintDialog;
    FFileName: string;
    FCurrentTime: string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute(Handle: HWND): Boolean;
    procedure Print;
    property DocTitle: string read FDocTitle write FDocTitle;
    property FileName: string read FFileName write FFileName;
    property CurrentTime: string read FCurrentTime write FCurrentTime;
    property Editor: TEditor read FEditor write FEditor;
  end;

implementation

uses
  SysUtils, Graphics;

{ TEditorPrint }

constructor TEditorPrint.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPrintDialog := TPrintDialog.Create(Self);
end;

destructor TEditorPrint.Destroy;
begin
  inherited;
end;

function TEditorPrint.Execute(Handle: HWND): Boolean;
begin
  Result := FPrintDialog.Execute(Handle);
end;

procedure TEditorPrint.Print;
const
  MarginLeft = 120;
  MarginRight = 120;
  MarginTop = 220;
  MarginBottom = 220;

var
  Range: TDSciRangeToFormat;
  LengthPrinted, LengthDoc: Integer;
  TextHeight, TextWidth: Integer;
  ShowLineNumber: Boolean;
  EdgeMode: Integer;
  PageStr: string;
begin
  if not Assigned(FEditor) then
    raise Exception.Create('Editor not set');
  Printer.Title := DocTitle;
  Printer.BeginDoc;
  Range.hdc := Printer.Handle;
  Range.hdcTarget := Printer.Handle;
  Range.rc.Left := MarginLeft;
  Range.rc.Top := MarginTop;
  Range.rc.Right := Printer.PageWidth - MarginRight;
  Range.rc.Bottom := Printer.PageHeight - MarginBottom;
  Range.rcPage.Left := 0;
  Range.rcPage.Top := 0;
  Range.rcPage.Right := Printer.PageWidth;
  Range.rcPage.Bottom := Printer.PageHeight;

  ShowLineNumber := FEditor.ShowLineNumber;
  FEditor.ShowLineNumber := False;
  EdgeMode := FEditor.GetEdgeMode;
  FEditor.SetEdgeMode(EDGE_NONE);
  LengthPrinted := 0;
  LengthDoc := FEditor.GetLength;
  Printer.Canvas.Font.Name := 'Arial';
  Printer.Canvas.Pen.Color := clBlack;
  while (LengthPrinted < LengthDoc) do
  begin
    // Print Source Code
		Range.chrg.cpMin := LengthPrinted;
		Range.chrg.cpMax := LengthDoc;
    FEditor.SetPrintColourMode(SC_PRINT_NORMAL);
    LengthPrinted := FEditor.FormatRange(True, Range);

    // Print Header
    Printer.Canvas.Font.Size := 7;
    Printer.Canvas.Font.Style := [fsBold];
    TextHeight := Printer.Canvas.TextHeight(FFileName + FCurrentTime);
    TextWidth := Printer.Canvas.TextWidth(FCurrentTime);
    Printer.Canvas.TextOut(Range.rc.Left + 5,
      Range.rc.Top - TextHeight div 4 - TextHeight div 2, FFileName);
    Printer.Canvas.TextOut(Range.rc.Right - TextWidth - 5,
      Range.rc.Top - TextHeight div 4 - TextHeight div 2, FCurrentTime);
    Printer.Canvas.MoveTo(Range.rc.Left, Range.rc.Top - TextHeight div 4);
    Printer.Canvas.LineTo(Range.rc.Right, Range.rc.Top - TextHeight div 4);

    // Print Footer
    Printer.Canvas.Font.Size := 8;
    Printer.Canvas.Font.Style := [];
    Printer.Canvas.Brush.Style := bsSolid;
    Printer.Canvas.Brush.Style := bsClear;
    PageStr := '-' + IntToStr(Printer.PageNumber) + '-';
    TextHeight := Printer.Canvas.TextHeight(PageStr);
    TextWidth := Printer.Canvas.TextWidth(PageStr);

    Printer.Canvas.TextOut(Range.rc.Left +
      (Range.rc.Right - Range.rc.Left - TextWidth) div 2,
      Range.rc.Bottom + TextHeight + TextHeight div 2, PageStr);
    Printer.Canvas.MoveTo(Range.rc.Left, Range.rc.Bottom + TextHeight div 4);
    Printer.Canvas.LineTo(Range.rc.Right, Range.rc.Bottom + TextHeight div 4);

    if (LengthPrinted < LengthDoc) then
      Printer.NewPage;
  end;
  FEditor.FormatRange(False, Range);
  Printer.EndDoc;
  FEditor.ShowLineNumber := ShowLineNumber;
  FEditor.SetEdgeMode(EdgeMode);
end;

end.
