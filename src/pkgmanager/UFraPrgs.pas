unit UFraPrgs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, UFrmWizard, UInstaller;

const
  {$EXTERNALSYM PBS_MARQUEE}
  PBS_MARQUEE = $0008;
  {$EXTERNALSYM PBM_SETMARQUEE}
  PBM_SETMARQUEE = WM_USER+10;

type
  TFraPrgs = class(TFrame)
    PainelAll: TPanel;
    LblDesc: TLabel;
    PrgBar: TProgressBar;
    BtnShow: TButton;
    ListDesc: TListView;
    procedure BtnShowClick(Sender: TObject);
    procedure WMUpdateStep(var Message: TMessage); message WM_UPDATESTEP;
    procedure Progress(Sender: TObject; Position, Size: Int64;
      Finished, Success: Boolean; Msg, FileName: String;
      var Action: TProgressAction);
  private
    { Private declarations }
  public
    { Public declarations }
    InfinityBar: Boolean;
    procedure SetProgress(Position: Integer);
    procedure SetProgsType(Infinity: Boolean);
    function ProgsTypeIsInfinity: Boolean;
    procedure AddDesc(Text: String);
    procedure UpdateStep;
    procedure ApplyTranslation;
  end;

var
  FraPrgs: TFraPrgs;

implementation

uses UFraSteps, ULanguages;

{$R *.dfm}

procedure TFraPrgs.WMUpdateStep(var Message: TMessage);
begin
  UpdateStep;
end;

procedure TFraPrgs.UpdateStep;
begin
  FraSteps.LblTitle.Caption := STR_FRM_PROGRESS[2];
  FraSteps.LblSubTitle.Caption := Format(STR_FRM_PROGRESS[3], [Installer.Name]);
end;

procedure TFraPrgs.ApplyTranslation;
begin
  BtnShow.Caption := STR_FRM_PROGRESS[1];
end;

procedure TFraPrgs.AddDesc(Text: String);
var
  Item: TListItem;
begin
  LblDesc.Caption := Text;
  Item := ListDesc.Items.Add;
  Item.Caption := Text;
  ListDesc.Scroll(0, Item.Top - (ListDesc.Height div 2));
  Application.ProcessMessages;
end;

procedure TFraPrgs.SetProgress(Position: Integer);
begin
  PrgBar.Position := Position;
end;

procedure TFraPrgs.SetProgsType(Infinity: Boolean);
begin
  InfinityBar := Infinity;
  if Infinity then
  begin
    SetWindowLong(PrgBar.Handle, GWL_STYLE,
      GetWindowLong(PrgBar.Handle, GWL_STYLE) or PBS_MARQUEE);
    SendMessage(PrgBar.Handle, PBM_SETMARQUEE, 1, 0);
  end
  else
  begin
    SetWindowLong(PrgBar.Handle, GWL_STYLE,
      GetWindowLong(PrgBar.Handle, GWL_STYLE) xor PBS_MARQUEE);
    SendMessage(PrgBar.Handle, PBM_SETMARQUEE, 0, 0);
  end;
end;

function TFraPrgs.ProgsTypeIsInfinity: Boolean;
begin
  Result := InfinityBar;
end;

procedure TFraPrgs.BtnShowClick(Sender: TObject);
begin
  BtnShow.Hide;
  ListDesc.Show;
end;


procedure TFraPrgs.Progress(Sender: TObject; Position, Size: Int64;
  Finished, Success: Boolean; Msg, FileName: String; var Action: TProgressAction);
var
  I: Integer;
begin
  Application.ProcessMessages;
  PrgBar.Max := Size;
  PrgBar.Position := Position;
  if not Finished and not Success then
  begin
    I := MessageBox(Handle, PChar(Msg + #10#10 + FileName + #10#10 +
      StringReplace(STR_FRM_PROGRESS[4], '\n', #10, [rfReplaceAll])),
      PChar(STR_FRM_WIZARD[9]), MB_ICONERROR + MB_ABORTRETRYIGNORE);
    case I of
      IDABORT:
      begin
        Action := paAbort;
        AddDesc(Msg + ': ' + FileName);
      end;
      IDRETRY: Action := paRetry;
      IDIGNORE: Action := paSkip;
    end;
    Exit;
  end;
  AddDesc(Msg + FileName);
  if Finished then
    FrmWizard.BtnNextClick(Self);
end;

end.
