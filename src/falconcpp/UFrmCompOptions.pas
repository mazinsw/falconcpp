unit UFrmCompOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TFrmCompOptions = class(TForm)
    PageControl1: TPageControl;
    BtnOk: TButton;
    BtnCancel: TButton;
    BtnApply: TButton;
    TSCompiler: TTabSheet;
    TSDirectories: TTabSheet;
    TSPrograms: TTabSheet;
    TSDebugger: TTabSheet;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnApplyClick(Sender: TObject);
  private
    { Private declarations }
    Loading: Boolean;
    procedure OptionsChange;
  public
    { Public declarations }
    procedure UpdateLangNow;
    procedure Load;
  end;

var
  FrmCompOptions: TFrmCompOptions;

implementation

uses UFrmMain, ULanguages;

{$R *.dfm}

procedure TFrmCompOptions.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #27) then
  begin
    Key := #0;
    Close;
  end;
end;

procedure TFrmCompOptions.OptionsChange;
begin
  if Loading then Exit;
  BtnApply.Enabled := True;
end;

procedure TFrmCompOptions.Load;
begin
//  
end;

procedure TFrmCompOptions.UpdateLangNow;
begin
//
end;

procedure TFrmCompOptions.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmCompOptions.FormDestroy(Sender: TObject);
begin
  FrmCompOptions := nil;
end;

procedure TFrmCompOptions.BtnOkClick(Sender: TObject);
begin
  if BtnApply.Enabled then
    BtnApply.Click;
  Close;
end;

procedure TFrmCompOptions.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmCompOptions.BtnApplyClick(Sender: TObject);
begin
  BtnApply.Enabled := False;
  {with FrmFalconMain.Config.Compiler do
  begin

  end;}
end;

end.
