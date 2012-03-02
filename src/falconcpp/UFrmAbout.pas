unit UFrmAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RichEditViewer, ComCtrls, XPPanels, ULanguages;

type
  TFormAbout = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Panel1: TPanel;
    Button1: TButton;
    Label6: TLabel;
    XPPanel1: TXPPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Memo1: TMemo;
    TabSheet4: TTabSheet;
    RichEditViewer1: TRichEditViewer;
    RichEditViewer2: TRichEditViewer;
    EditTranslators: TRichEditViewer;
    procedure Button1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    procedure LoadTranslators(Languages: TFalconLanguages);
  end;

var
  FormAbout: TFormAbout;

implementation

{$R *.dfm}

procedure TFormAbout.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TFormAbout.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then Close;
end;

procedure TFormAbout.LoadTranslators(Languages: TFalconLanguages);
var
  I: Integer;
  S: String;
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
var
  rs: TResourceStream;
begin
  rs := TResourceStream.Create(HInstance, 'ICONFAL', RT_RCDATA);
  rs.Position := 0;
  Image1.Picture.Icon.LoadFromStream(rs);
  rs.Free;
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
