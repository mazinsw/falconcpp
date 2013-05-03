unit UFrmVisualCppOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFrmVisualCppOptions = class(TForm)
    CboConfig: TComboBox;
    Label1: TLabel;
    BtnOk: TButton;
    BtnCancel: TButton;
    procedure BtnOkClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

function ShowVisualCppOptions(ParentWindow: HWND; ConfigList: TStrings;
  var ItemIndex: Integer): Boolean;

implementation

{$R *.dfm}

function ShowVisualCppOptions(ParentWindow: HWND; ConfigList: TStrings;
  var ItemIndex: Integer): Boolean;
var
  FrmVisualCppOptions: TFrmVisualCppOptions;
begin
  FrmVisualCppOptions := TFrmVisualCppOptions.CreateParented(ParentWindow);
  FrmVisualCppOptions.CboConfig.Items.AddStrings(ConfigList);
  if (ItemIndex >= 0) and (ItemIndex < ConfigList.Count) then
    FrmVisualCppOptions.CboConfig.ItemIndex := ItemIndex;
  if (FrmVisualCppOptions.CboConfig.ItemIndex < 0) and (ConfigList.Count > 0) then
    FrmVisualCppOptions.CboConfig.ItemIndex := 0;
  Result := FrmVisualCppOptions.ShowModal = mrOk;
  if Result then
    ItemIndex := FrmVisualCppOptions.CboConfig.ItemIndex;
  FrmVisualCppOptions.Free;
end;

{ TFrmVisualCppOptions }

procedure TFrmVisualCppOptions.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if ParentWindow <> 0 then
  begin
    Params.Style := Params.Style and not WS_CHILD;
    if BorderStyle = bsNone then
      Params.Style := Params.Style or WS_POPUP;
  end;
end;

procedure TFrmVisualCppOptions.BtnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFrmVisualCppOptions.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

end.
