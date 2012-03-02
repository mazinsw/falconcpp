unit UFrmGotoLine;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ExtCtrls, ComCtrls, EditAlign;

type
  TFormGotoLine = class(TForm)
    BtnOk: TButton;
    BtnCancel: TButton;
    Bevel1: TBevel;
    LblLine: TLabel;
    EditLine: TEditAlign;
    UpDown: TUpDown;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure EditLineKeyPress(Sender: TObject; var Key: Char);
    procedure EditLineChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowWithRange(MinLin, LineStart, LineEnd: Integer);
    procedure SelectLine(Line: Integer);
  end;

var
  FormGotoLine: TFormGotoLine;

implementation

uses UFrmMain, UFileProperty;

{$R *.dfm}

procedure TFormGotoLine.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFormGotoLine.FormDestroy(Sender: TObject);
begin
  FormGotoLine := nil;
end;

procedure TFormGotoLine.ShowWithRange(MinLin, LineStart, LineEnd: Integer);
begin
  UpDown.Min := MinLin;
  UpDown.Max := LineEnd;
  UpDown.Position := LineStart;
  EditLine.SelectAll;
  LblLine.Caption := Format('Line (%d - %d):', [MinLin, LineEnd]);
  ShowModal;
end;

procedure TFormGotoLine.FormResize(Sender: TObject);
begin
  EditLine.Width := ClientWidth - 2 * EditLine.Left - UpDown.Width - 1;
end;

procedure TFormGotoLine.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TFormGotoLine.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFormGotoLine.BtnOkClick(Sender: TObject);
begin
  SelectLine(UpDown.Position);
end;

procedure TFormGotoLine.SelectLine(Line: Integer);
var
  sheet: TFilePropertySheet;
begin
  if not FrmFalconMain.GetActiveSheet(sheet) then
    Exit;
  FrmFalconMain.GotoLineAndAlignCenter(sheet.Memo, Line);
  Close;
end;

procedure TFormGotoLine.EditLineKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
    Key := #0;
  if Key = #13 then
  begin
    Key := #0;
    SelectLine(UpDown.Position);
  end;
  if not (Key in ['0'..'9', #8, #27]) then
    Key := #0;
end;

procedure TFormGotoLine.EditLineChange(Sender: TObject);
begin
  if Length(EditLine.Text) > 0 then
    UpDown.Position := StrToInt(EditLine.Text);
end;

end.
