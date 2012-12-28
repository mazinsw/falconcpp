unit UFrmHelp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFrmHelp = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

var
  FrmHelp: TFrmHelp;

implementation

uses ULanguages;

{$R *.dfm}

procedure TFrmHelp.FormCreate(Sender: TObject);
begin
  Caption := STR_FRM_PKG_MAN[1] + ' - [' + STR_FRM_PKG_MAN[22] + ']';
  Button1.Caption := STR_FRM_PKG_MAN[32];
  Label1.Caption := 'Falcon C++ Package Manager'#10+
  '=========================='#10#10+
  #9'Install *.fpk, *.DevPak C/C++ Packages'#10+
  'Drag drop packages to install or'#10+
  'click on Install button or Packages->Install menu'#10+
  'or press Insert Key'#10#10+
  '============ Command line ==========='#10#10+
  'Install package:'#10+
  #9'PkgManager.exe   [/I | /install | -I | --install]   [/S | /silent | -S | --silent]   mypack.fpk'#10+
  'Example:'#10+
  #9'PkgManager.exe mypack.fpk'#10#10+
  'Uninstall package:'#10+
  #9'PkgManager.exe   (/U | /uninstall | -U | --uninstall)   [/S | /silent | -S | --silent]   mypack.fpk'#10+
  'Example:'#10+
  #9'PkgManager.exe --uninstall --silent mypack.fpk'#10#10+
  '[?] optional'#10+
  '(?) need'#10+
  '[/I | /install | -I | --install],'#9'install an package'#10+
  '(/U | /uninstall | -U | --uninstall),'#9'uninstall an package'#10+
  '[/S | /silent | -S | --silent],'#9'activate silent mode'#10;
end;

procedure TFrmHelp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmHelp.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if ParentWindow <> 0 then
  begin
    Params.Style := Params.Style and not WS_CHILD;
    if BorderStyle = bsNone then
      Params.Style := Params.Style or WS_POPUP;
  end;
end;

procedure TFrmHelp.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TFrmHelp.Button1Click(Sender: TObject);
begin
  Close;
end;

end.
