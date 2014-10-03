unit UFrmUninstall;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, UInstaller;

type
  TFrmUninstall = class(TForm)
    GBoxFile: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    LblVer: TLabel;
    LblName: TLabel;
    BtnShow: TButton;
    ListDesc: TListView;
    LblDesc: TLabel;
    PrgBar: TProgressBar;
    BtnOk: TButton;
    procedure Progress(Sender: TObject; Position, Size: Int64;
      Finished, Success: Boolean; Msg, FileName: String;
      var Action: TProgressAction);
    procedure SetProgress(Position: Integer);
    procedure AddDesc(Text: String);
    procedure BtnShowClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

var
  FrmUninstall: TFrmUninstall;

implementation

uses ULanguages;

{$R *.dfm}

procedure TFrmUninstall.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if ParentWindow <> 0 then
  begin
    Params.Style := Params.Style and not WS_CHILD;
    if BorderStyle = bsNone then
      Params.Style := Params.Style or WS_POPUP;
  end;
end;

procedure TFrmUninstall.Progress(Sender: TObject; Position, Size: Int64;
  Finished, Success: Boolean; Msg, FileName: String;
  var Action: TProgressAction);
var
  FalconHandle, PkgHandle: THandle;
begin
  Application.ProcessMessages;
  PrgBar.Max := Size;
  PrgBar.Position := Position;
  AddDesc(Msg);
  if Finished then
  begin
    BtnOk.Enabled := True;
    BtnOk.SetFocus;
    EnableMenuItem(GetSystemMenu(Handle, False),
        SC_CLOSE, MF_ENABLED);
    //reload all falcon templates
    FalconHandle := FindWindow('TFrmFalconMain', nil);
    if FalconHandle <> 0 then
      PostMessage(FalconHandle, WM_RELOADFTM, 0, 0);
    //reload all falcon packages
    PkgHandle := FindWindow('TFrmPkgMan', nil);
    if PkgHandle <> 0 then
      PostMessage(PkgHandle, WM_RELOADPKG, 0, 0);
  end;
end;

procedure TFrmUninstall.SetProgress(Position: Integer);
begin
  PrgBar.Position := Position;
end;

procedure TFrmUninstall.AddDesc(Text: String);
var
  Item: TListItem;
begin
  LblDesc.Caption := Text;
  Item := ListDesc.Items.Add;
  Item.Caption := Text;
  ListDesc.Scroll(0, Item.Top - (ListDesc.Height div 2));
  Application.ProcessMessages;
end;

procedure TFrmUninstall.BtnShowClick(Sender: TObject);
begin
  BtnShow.Hide;
  ClientHeight := ListDesc.Top + ListDesc.Height + BtnOk.Height +
    2 * (BtnShow.Top - PrgBar.Top - PrgBar.Height);
  BtnOk.Top := ListDesc.Top + ListDesc.Height +
    1 * (BtnShow.Top - PrgBar.Top - PrgBar.Height);
  ListDesc.Show;
end;

procedure TFrmUninstall.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmUninstall.BtnOkClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmUninstall.FormCreate(Sender: TObject);
begin
  EnableMenuItem(GetSystemMenu(Handle, False),
        SC_CLOSE, MF_DISABLED);
  Caption := STR_FRM_UNINSTALL[1];
  GBoxFile.Caption := STR_FRM_DESC[5];
  Label5.Caption := STR_FRM_DESC[6];
  LblName.Left := Label5.Left + Label5.Width + 5;
  Label4.Caption := STR_FRM_DESC[7];
  LblVer.Left := Label4.Left + Label4.Width + 5;
  BtnShow.Caption := STR_FRM_PROGRESS[1];
  BtnOk.Caption := STR_FRM_UNINSTALL[2];
end;

procedure TFrmUninstall.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) and BtnOk.Enabled then Close;
end;

end.
