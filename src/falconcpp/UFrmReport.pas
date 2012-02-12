unit UFrmReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SendMail, StdCtrls, ExtCtrls, ExtDlgs, JPeg, PNGImage, GIFImage;

type
  TFrmReport = class(TForm)
    ImgErr: TImage;
    PanelImg: TPanel;
    BtnSend: TButton;
    BtnClose: TButton;
    GrbImg: TGroupBox;
    BtnLoad: TButton;
    GrbMsg: TGroupBox;
    MemoMsg: TMemo;
    SendMail: TSendMail;
    OPDlg: TOpenPictureDialog;
    BtnRem: TButton;
    procedure BtnLoadClick(Sender: TObject);
    procedure BtnSendClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure BtnRemClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmReport: TFrmReport;

implementation

{$R *.dfm}

procedure TFrmReport.BtnLoadClick(Sender: TObject);
begin
  if OPDlg.Execute then
  begin
    SendMail.Annex.Text := OPDlg.FileName;
    try
      ImgErr.Picture.LoadFromFile(OPDlg.FileName);
    except
      SendMail.Annex.Clear;
      MessageBox(Handle, 'Picture error!', 'Falcon C++',
      MB_ICONERROR);
    end;
  end;
end;

procedure TFrmReport.BtnSendClick(Sender: TObject);
begin
  if SendMail.Send(MemoMsg.Lines) then
    MessageBox(Handle, 'Report sent successfully!', 'Falcon C++',
      MB_ICONINFORMATION)
  else
    MessageBox(Handle, 'Error sending report!', 'Falcon C++',
      MB_ICONEXCLAMATION);
end;

procedure TFrmReport.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  FrmReport.FreeOnRelease;
  FrmReport := nil;
end;

procedure TFrmReport.FormCreate(Sender: TObject);
begin
  SendMail.Login := 'falconcpp';
  SendMail.Pass := 'Falcon123456';
end;

procedure TFrmReport.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmReport.BtnRemClick(Sender: TObject);
begin
  SendMail.Annex.Clear;
  ImgErr.Picture := nil;
end;

procedure TFrmReport.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #27) then Close;
end;

end.
