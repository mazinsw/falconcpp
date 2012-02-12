unit UFraDesc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, UFrmWizard;

type
  TFraDesc = class(TFrame)
    PainelAll: TPanel;
    LblEspReq: TLabel;
    LblEspDisp: TLabel;
    GBoxFile: TGroupBox;
    Label1: TLabel;
    TextDesc: TLabel;
    TextPkgDesc: TMemo;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LblSite: TLabel;
    LblVer: TLabel;
    LblName: TLabel;
    procedure Init;
    procedure LblSiteClick(Sender: TObject);
    procedure UpdateStep;
    procedure WMUpdateStep(var Message: TMessage); message WM_UPDATESTEP;
  private
    { Private declarations }
  public
    { Public declarations }
    WzdRestore: Boolean;
  end;

var
  FraDesc: TFraDesc;

implementation

uses UInstaller, UFraSteps;

{$R *.dfm}

procedure TFraDesc.WMUpdateStep(var Message: TMessage);
begin
  UpdateStep;
end;

procedure TFraDesc.UpdateStep;
begin
  FraSteps.LblTitle.Caption := 'Package description';
  FraSteps.LblSubTitle.Caption := Format('Package details of %s.', [Installer.Name]);
end;

function FormatSize(Size:Int64): String;
begin
  case Size of
    1024..1024*1023: Result := FormatFloat('0.0 KB', Size/1024);
    1024*1024..1024*1024*1023: Result := FormatFloat('0.0 MB', Size/(1024*1024));
  else
    Result := FormatFloat('0.0 GB', Size/(1024*1024*1024));
  end;
end;

function SpaceAvailabre(Directory: String): Int64;
var
  FreeAvailable, TotalSpace, TotalFree : Int64;
begin
  GetDiskFreeSpaceEx(PChar(Directory), FreeAvailable, TotalSpace, @TotalFree);
  Result := FreeAvailable;
end;

procedure TFraDesc.Init;
begin
  LblEspReq.Caption := 'Space required: ' + FormatSize(Installer.PkgSize);
  LblEspDisp.Caption := 'Space available: ' +
    FormatSize(SpaceAvailabre(ExtractFilePath('C:')));
  LblName.Caption := Installer.Name;
  LblVer.Caption := Installer.Version;
  if Length(Trim(Installer.WebSiteCaption)) = 0 then
  begin
    LblSite.Caption := Installer.WebSite;
  end
  else
  begin
    LblSite.Hint := Installer.WebSite;
    LblSite.Caption := Installer.WebSiteCaption;
  end;
  TextPkgDesc.Text := Installer.Description;
end;

procedure TFraDesc.LblSiteClick(Sender: TObject);
begin
  Execute(Installer.WebSite);
end;

end.
