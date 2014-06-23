unit UFrmGotoLine;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, EditAlign;

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
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    procedure ShowWithRange(MinLin, LineStart, LineEnd: Integer);
    procedure SelectLine(Line: Integer);
    procedure UpdateLangNow;
  end;

var
  FormGotoLine: TFormGotoLine;

implementation

uses UFrmMain, USourceFile, ULanguages;

{$R *.dfm}

procedure TFormGotoLine.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if ParentWindow <> 0 then
  begin
    Params.Style := Params.Style and not WS_CHILD;
    if BorderStyle = bsNone then
      Params.Style := Params.Style or WS_POPUP;
  end;
end;

procedure TFormGotoLine.UpdateLangNow;
begin
  Caption := STR_FRM_GOTOLINE[1];
  BtnOk.Caption := STR_FRM_PROP[14];
  BtnCancel.Caption := STR_FRM_PROP[15];
end;

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
  LblLine.Caption := Format(STR_FRM_GOTOLINE[2], [MinLin, LineEnd]);
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
  sheet: TSourceFileSheet;
begin
  if not FrmFalconMain.GetActiveSheet(sheet) then
    Exit;
  FrmFalconMain.GotoLineAndAlignCenter(sheet.Editor, Line);
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
  if not CharInSet(Key, ['0'..'9', #8, #27]) then
    Key := #0;
end;

procedure TFormGotoLine.EditLineChange(Sender: TObject);
begin
  if Length(EditLine.Text) > 0 then
    UpDown.Position := StrToInt(EditLine.Text);
end;

procedure TFormGotoLine.FormCreate(Sender: TObject);
begin
  UpdateLangNow;
end;

procedure TFormGotoLine.FormShow(Sender: TObject);
begin
  EditLine.SelectAll;
end;

end.
