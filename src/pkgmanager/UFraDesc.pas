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
    procedure ApplyTranslation;
  end;

var
  FraDesc: TFraDesc;

implementation

uses UInstaller, UFraSteps, PkgUtils, ULanguages, SystemUtils;

{$R *.dfm}

procedure TFraDesc.WMUpdateStep(var Message: TMessage);
begin
  UpdateStep;
end;

procedure TFraDesc.UpdateStep;
begin
  FraSteps.LblTitle.Caption := STR_FRM_DESC[1];
  FraSteps.LblSubTitle.Caption := Format(STR_FRM_DESC[2], [Installer.Name]);
end;

function FormatSize(Size: Int64): string;
begin
  if Size < 1024 then
    Result := FormatFloat('0 B', Size)
  else if Size < 1024 * 1024 then
    Result := FormatFloat('0.0 kB', Size / 1024)
  else if Size < 1024 * 1024 * 1024 then
    Result := FormatFloat('0.0 MB', Size / (1024 * 1024))
  else
    Result := FormatFloat('0.00 GB', Size / (1024 * 1024 * 1024));
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
  LblEspReq.Caption := STR_FRM_DESC[3] + ' ' + FormatSize(Installer.PkgSize);
  LblEspDisp.Caption := STR_FRM_DESC[4] + ' ' +
    FormatSize(SpaceAvailabre(ExtractFilePath(GetCompilerDir)));
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

procedure TFraDesc.ApplyTranslation;
begin
  GBoxFile.Caption := STR_FRM_DESC[5];
  Label4.Caption := STR_FRM_DESC[6];
  LblName.Left := Label4.Left + Label4.Width + 5;
  Label3.Caption := STR_FRM_DESC[7];
  LblVer.Left := Label3.Left + Label3.Width + 5;
  Label2.Caption := STR_FRM_DESC[8];
  LblSite.Left := Label2.Left + Label2.Width + 5;
  TextDesc.Caption := STR_FRM_DESC[9];
  Label1.Caption := STR_FRM_DESC[10];
end;

end.
