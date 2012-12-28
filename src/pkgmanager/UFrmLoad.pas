unit UFrmLoad;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, UInstaller;

type
  TFrmLoad = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    LblPrgs: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure SetProgress(Sender: TObject; Position, Size: Int64;
      Finished, Success: Boolean; Msg, FileName: String; var Action: TProgressAction);
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

var
  FrmLoad: TFrmLoad;

implementation

uses ULanguages;

{$R *.dfm}

procedure TFrmLoad.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params do
  begin
    Style := Style or WS_DLGFRAME;
    if ParentWindow <> 0 then
    begin
      Style := Style and not WS_CHILD;
      if BorderStyle = bsNone then
        Style := Style or WS_POPUP;
    end;
  end;
end;

procedure TFrmLoad.SetProgress(Sender: TObject; Position, Size: Int64;
  Finished, Success: Boolean; Msg, FileName: String;
  var Action: TProgressAction);
var
  Percent: Integer;
begin
  Application.ProcessMessages;
  Percent := 0;
  if (Size > 0) then
    Percent := Round((Position*100)/Size);
  LblPrgs.Caption := Format(STR_FRM_LOADING[2], [Percent]);
end;

procedure TFrmLoad.FormCreate(Sender: TObject);
begin
  Image1.Picture.Icon.Assign(Application.Icon);
  Label1.Caption := STR_FRM_LOADING[1];
  LblPrgs.Caption := Format(STR_FRM_LOADING[2], [0]);
end;

end.
