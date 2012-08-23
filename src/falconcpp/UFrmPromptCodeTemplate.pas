unit UFrmPromptCodeTemplate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TOkButtonEvent = procedure(Sender: TObject; const Name, Description: string;
    Data: Pointer; var Abort: Boolean) of object;
  TFrmPromptCodeTemplate = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EditName: TEdit;
    Label2: TLabel;
    EditDesc: TEdit;
    BtnCancel: TButton;
    BtnOk: TButton;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure BtnOkClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure EditNameKeyPress(Sender: TObject; var Key: Char);
    procedure EditDescKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    fOnOkButtonClick: TOkButtonEvent;
    fData: Pointer;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    procedure UpdateLangNow;
  end;

var
  FrmPromptCodeTemplate: TFrmPromptCodeTemplate;

function PromptDialog(ParentWindow: HWND; const Caption: string; var Name, Description: string;
  Data: Pointer; OkButtonEvent: TOkButtonEvent = nil): Boolean;

implementation

uses ULanguages;

{$R *.dfm}

function PromptDialog(ParentWindow: HWND; const Caption: string; var Name, Description: string;
  Data: Pointer; OkButtonEvent: TOkButtonEvent = nil): Boolean;
begin
  Result := False;
  if not Assigned(FrmPromptCodeTemplate) then
    FrmPromptCodeTemplate := TFrmPromptCodeTemplate.CreateParented(ParentWindow);
  FrmPromptCodeTemplate.Caption := Caption;
  FrmPromptCodeTemplate.EditName.Text := Name;
  FrmPromptCodeTemplate.EditDesc.Text := Description;
  FrmPromptCodeTemplate.fData := Data;
  FrmPromptCodeTemplate.fOnOkButtonClick := OkButtonEvent;
  if FrmPromptCodeTemplate.ShowModal = mrOk then
  begin
    Name := FrmPromptCodeTemplate.EditName.Text;
    Description := FrmPromptCodeTemplate.EditDesc.Text;
  end
  else
  begin
    FrmPromptCodeTemplate.Free;
    Exit;
  end;
  FrmPromptCodeTemplate.Free;
  Result := True;
end;

procedure TFrmPromptCodeTemplate.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if ParentWindow <> 0 then
  begin
    Params.Style := Params.Style and not WS_CHILD;
    if BorderStyle = bsNone then
      Params.Style := Params.Style or WS_POPUP;
  end;
end;

procedure TFrmPromptCodeTemplate.UpdateLangNow;
begin
  Label1.Caption := STR_FRM_PROMPT_CODE[1];
  Label2.Caption := STR_FRM_PROMPT_CODE[2];
end;

procedure TFrmPromptCodeTemplate.FormKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key = #27) then
  begin
    Key := #0;
    ModalResult := mrCancel;
  end;
end;

procedure TFrmPromptCodeTemplate.BtnOkClick(Sender: TObject);
var
  Abort: Boolean;
begin
  if Assigned(fOnOkButtonClick) then
  begin
    Abort := False;
    fOnOkButtonClick(Self, EditName.Text, EditDesc.Text, fData, Abort);
    if Abort then
    begin
      EditName.SetFocus;
      Exit;
    end;
  end;
  ModalResult := mrOk;
end;

procedure TFrmPromptCodeTemplate.FormDestroy(Sender: TObject);
begin
  FrmPromptCodeTemplate := nil;
end;

procedure TFrmPromptCodeTemplate.BtnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmPromptCodeTemplate.EditNameKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Perform(WM_NEXTDLGCTL, 0, 0);
    Key := #0;
  end;
end;

procedure TFrmPromptCodeTemplate.EditDescKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    BtnOkClick(Sender);
  end;
end;

procedure TFrmPromptCodeTemplate.FormCreate(Sender: TObject);
begin
  UpdateLangNow;
end;

end.
