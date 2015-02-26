unit UFrmAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, XPPanels, ULanguages;

type
  TFormAbout = class(TForm)
    Image1: TImage;
    LblNameVersion: TLabel;
    Panel1: TPanel;
    BtnOk: TButton;
    Label6: TLabel;
    XPPanel1: TXPPanel;
    PageControl1: TPageControl;
    TSLicence: TTabSheet;
    TSDevelopers: TTabSheet;
    TSTranslator: TTabSheet;
    TSTesters: TTabSheet;
    EditDevelopers: TRichEdit;
    EditTranslators: TRichEdit;
    EditTesters: TRichEdit;
    EditLicense: TRichEdit;
    procedure BtnOkClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    procedure InitRichEditURLDetection(RE: TRichEdit);
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    procedure LoadTranslators(Languages: TFalconLanguages);
    procedure UpdateLangNow;
  end;

var
  FormAbout: TFormAbout;

implementation

uses UFrmMain, UUtils, RichEdit;

{$R *.dfm}

procedure TFormAbout.UpdateLangNow;
begin
  Caption := STR_FRM_ABOUT[1];
  Label6.Caption := Format(STR_FRM_ABOUT[2],
    ['Windows XP, Windows Vista and Windows 7']);
  TSLicence.Caption := STR_FRM_ABOUT[3];
  TSDevelopers.Caption := STR_FRM_ABOUT[4];
  TSTranslator.Caption := STR_FRM_ABOUT[5];
  TSTesters.Caption := STR_FRM_ABOUT[6];
  BtnOk.Caption := STR_FRM_PROP[14];
end;

procedure TFormAbout.BtnOkClick(Sender: TObject);
begin
  Close;
end;

procedure TFormAbout.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then
    Close;
end;

procedure TFormAbout.InitRichEditURLDetection(RE: TRichEdit);
var
  mask: Word;
  text: string;
begin
  mask := SendMessage(RE.Handle, EM_GETEVENTMASK, 0, 0);
  SendMessage(RE.Handle, EM_SETEVENTMASK, 0, mask or ENM_LINK);
  SendMessage(RE.Handle, EM_AUTOURLDETECT, Integer(True), 0);
  text := RE.Text;
  RE.Lines.Text := '';
  RE.Lines.Text := text;
end;

procedure TFormAbout.LoadTranslators(Languages: TFalconLanguages);
var
  I: Integer;
  S: string;
begin
  EditTranslators.Clear;
  for I := 0 to Languages.Count - 1 do
  begin
    S := Languages.Items[I].Translator;
    if Languages.Items[I].Email <> '' then
    begin
      if Pos('@', Languages.Items[I].Email) > 0 then
        S := S + ': mailto:' + Languages.Items[I].Email
      else
        S := S + ': ' + Languages.Items[I].Email;
    end;
    if S <> '' then
      EditTranslators.Lines.Add(S);
  end;
end;

procedure TFormAbout.FormCreate(Sender: TObject);
begin
  AssignAppIcon(Image1.Picture);
  InitRichEditURLDetection(EditLicense);
  InitRichEditURLDetection(EditDevelopers);
  InitRichEditURLDetection(EditTranslators);
  InitRichEditURLDetection(EditTesters);
  UpdateLangNow;
  LblNameVersion.Caption := Format('Falcon C++ v%d.%d.%d.%d',
    [FrmFalconMain.FalconVersion.Major,
     FrmFalconMain.FalconVersion.Minor,
     FrmFalconMain.FalconVersion.Release,
     FrmFalconMain.FalconVersion.Build]);
end;

procedure TFormAbout.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params do
  begin
    Style := Style or WS_POPUPWINDOW;
    ExStyle := ExStyle or WS_EX_TOOLWINDOW;
  end;
end;

procedure TFormAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFormAbout.FormDestroy(Sender: TObject);
begin
  FormAbout := nil;
end;

end.
