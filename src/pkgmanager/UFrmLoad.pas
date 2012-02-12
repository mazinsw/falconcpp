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

{$R *.dfm}

procedure TFrmLoad.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or WS_DLGFRAME;
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
  LblPrgs.Caption := 'unpacking data: ' + IntToStr(Percent) + '%';
end;

procedure TFrmLoad.FormCreate(Sender: TObject);
begin
  Image1.Picture.Icon.Assign(Application.Icon);
end;

end.
