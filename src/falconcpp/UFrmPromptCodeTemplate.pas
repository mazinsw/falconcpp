unit UFrmPromptCodeTemplate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TOkButtonEvent = procedure(Sender: TObject; const Name, Description: String;
    Data: Pointer; var Abort: Boolean) of Object;
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
  private
    { Private declarations }
    fOnOkButtonClick: TOkButtonEvent;
    fData: Pointer; 
  public
    { Public declarations }
  end;

var
  FrmPromptCodeTemplate: TFrmPromptCodeTemplate;

function PromptDialog(const Caption: String; var Name, Description: String;
  Data: Pointer; OkButtonEvent: TOkButtonEvent = nil): Boolean;

implementation

{$R *.dfm}

function PromptDialog(const Caption: String; var Name, Description: String;
  Data: Pointer; OkButtonEvent: TOkButtonEvent = nil): Boolean;
begin
  Result := False;
  if not Assigned(FrmPromptCodeTemplate) then
    FrmPromptCodeTemplate := TFrmPromptCodeTemplate.Create(nil);
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

end.
