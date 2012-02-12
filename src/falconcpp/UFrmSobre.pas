unit UFrmSobre;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Gradient, StdCtrls, ExtCtrls;

type
  TfrmSobre = class(TForm)
    Gradient1: TGradient;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Button1: TButton;
    Image1: TImage;
    procedure Button1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSobre: TfrmSobre;

implementation

{$R *.dfm}

procedure TfrmSobre.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmSobre.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then Close;
end;

procedure TfrmSobre.FormCreate(Sender: TObject);
begin
  if (GetSystemDefaultLangID <> 1046) then
  begin
    Label2.Caption := 'Developer: Mazin SW';
    Label3.Caption := 'Company: MZSW';
    Label6.Caption := 'Compatibility: Windows XP and Windows 7';
    Caption := 'About';
  end;
  Image1.Picture.Icon.Assign(Application.Icon);
end;

end.
