unit UFrmUpdate;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, StdCtrls,
  ExtCtrls, FileDownload, UUtils, IniFiles, ThreadFileDownload,
  VistaAltFixUnit, Messages;

type

  TUpdateWizard = (uwGetVersion, uwDownload, uwInstall, uwRestart, uwOk, uwCancel);
  TFrmUpdate = class(TForm)
    Panel1: TPanel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Panel3: TPanel;
    LblAction: TLabel;
    BtnCancel: TButton;
    UpdateDownload: TFileDownload;
    BtnUpdate: TButton;
    FileDownload: TFileDownload;
    PnlFra: TPanel;
    VistaAltFix1: TVistaAltFix;
    procedure UpdateLangNow;
    procedure FormCreate(Sender: TObject);
    procedure StartUpdate;
    procedure NewVersion(UpdateXML: String);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    function IsAppOpen(const ClassName: String): Boolean;
    procedure BtnCancelClick(Sender: TObject);
    procedure UpdateDownloadFinish(Sender: TObject; State: TDownloadState;
      Canceled: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ExecutorInstallFinish(Sender: TObject);
    procedure BtnUpdateClick(Sender: TObject);
    procedure FileDownloadFinish(Sender: TObject; State: TDownloadState;
      Canceled: Boolean);
    procedure FileDownloadProgress(Sender: TObject; ReceivedBytes,
      CalculatedFileSize: Cardinal);
    procedure FileDownloadStart(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Stage    : TUpdateWizard;//install wizard stage
    Install  : Boolean;      //start and install
    FileName : String;       //dest filename to extract
  end;

var
  FrmUpdate: TFrmUpdate;

implementation

uses UFraGetVer, UFraUpdate, CompressUtils, ExecWait;

{$R *.dfm}

//update user selected language in Falcon C++
procedure TFrmUpdate.UpdateLangNow;
begin
  LoadLang;
  Caption := STR_FRM_UPD[1];
  Application.Title := STR_FRM_UPD[1];
  LblAction.Caption := STR_FRM_UPD[2];
  BtnUpdate.Caption := STR_FRM_UPD[3];
  FraGetVer.LblDesc.Caption := STR_FRM_UPD[14];
  FraUpdate.LblChanges.Caption := STR_FRM_UPD[15];
end;

procedure TFrmUpdate.FormCreate(Sender: TObject);
begin
  FraGetVer := TFraGetVer.Create(Self);
  FraGetVer.Parent := PnlFra;
  FraUpdate := TFraUpdate.Create(Self);
  { TODO -oMazin -c : resolve flik:FraGetVer.PrgsUpdate.DoubleBuffered := True; 17/02/2013 22:39:53 }
  UpdateLangNow;
  Install := (ParamCount = 1);//has URL as parameter
  if Install then
  begin
    NewVersion(ParamStr(1));
    BtnUpdateClick(Sender);
  end
  else
    StartUpdate;//get update information
end;

procedure TFrmUpdate.StartUpdate;
begin
  Stage := uwGetVersion;//first stage
  SetProgsType(FraGetVer.PrgsUpdate, True);//undefined time
  UpdateDownload.URL := FALCON_URL_UPDATE;
  UpdateDownload.FileName := GetTempDirectory + 'FalconUpdate.xml';//save to
  if FileExists(UpdateDownload.FileName) then
    DeleteFile(UpdateDownload.FileName);
  UpdateDownload.Start;//start download
end;

procedure TFrmUpdate.NewVersion(UpdateXML: String);
begin
  Stage := uwDownload;//download stage
  FraUpdate.Parent := PnlFra;//update form stage
  FraGetVer.Parent := nil;
  FraUpdate.Load(UpdateXML); //update stage
end;

procedure TFrmUpdate.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #27) then
  begin
    Key := #0;
    BtnCancelClick(Sender);
  end;
end;

function TFrmUpdate.IsAppOpen(const ClassName: String): Boolean;
begin
  Result := FindWindow(PChar(ClassName), nil) > 0;
end;

procedure TFrmUpdate.BtnCancelClick(Sender: TObject);
begin
  Stage := uwCancel;
  if UpdateDownload.IsBusy then
    UpdateDownload.Stop;
  if FileDownload.IsBusy then
    FileDownload.Stop;
  //if not UpdateDownload.IsBusy and not FileDownload.IsBusy then
    Close;
end;

procedure TFrmUpdate.UpdateDownloadFinish(Sender: TObject;
  State: TDownloadState; Canceled: Boolean);
begin
  if (Stage = uwCancel) then
  begin
    Close;
    Exit;
  end;
  SetProgsType(FraGetVer.PrgsUpdate, False);
  if not Canceled then
  begin
    if FileExists(UpdateDownload.FileName) and (State <> dsError) then
    begin
      Stage := uwDownload;
      FraUpdate.Parent := PnlFra;
      FraGetVer.Parent := nil;
      if FraUpdate.Load(UpdateDownload.FileName) then
        BtnUpdate.SetFocus;
    end
    else
    begin
      LblAction.Caption := STR_FRM_UPD[5];
      FraGetVer.PrgsUpdate.Hide;
      FraGetVer.LblDesc.Caption := STR_FRM_UPD[6];
      BtnCancel.Caption := STR_FRM_UPD[22];
    end;
  end;
end;

procedure TFrmUpdate.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Stage := uwCancel;
  UpdateDownload.Stop;
  FileDownload.Stop;
//  if not UpdateDownload.IsBusy and not FileDownload.IsBusy then
//  begin
    if Assigned(FrmUpdate) then
    begin
      Action := caFree;
//      FrmUpdate := nil;
    end;
//  end
//  else
//    Action := caNone;
end;

procedure TFrmUpdate.ExecutorInstallFinish(Sender: TObject);
begin
  BtnCancel.Caption := STR_FRM_UPD[23];
  FraUpdate.LblDesc.Caption := STR_FRM_UPD[7];
  FraUpdate.LblChanges.Hide;
  FraUpdate.MemoChanges.Hide;
  LblAction.Caption := STR_FRM_UPD[8];
  Stage := uwOk;
  DeleteFile(GetTempDirectory + FileName);
end;

procedure TFrmUpdate.BtnUpdateClick(Sender: TObject);
var
  temp: String;
begin
  temp := ReadIniFile('Update', 'LastTry', '0.0.0.0');
  case CompareVersion(FraUpdate.SiteVersion, ParseVersion(temp)) of
    -1, 1://site diff - restart download
    begin
      if FileExists(FileDownload.FileName) then
        DeleteFile(FileDownload.FileName);//delete incomplete old file
    end;
  end;
  if not Install then
    BtnCancel.SetFocus;
  FileDownload.Start;
end;

procedure TFrmUpdate.FileDownloadFinish(Sender: TObject;
  State: TDownloadState; Canceled: Boolean);
var
  Extracted: Boolean;
  ExtractedFileName, DownloadedFileName: String;
  I: Integer;
begin
  if Stage = uwCancel then
  begin
    Close;
    Exit;
  end;
  FraUpdate.PrgsUpdate.Hide;
  if not Canceled and (State <> dsError) then
  begin
    DownloadedFileName := FileDownload.URL;
    DownloadedFileName := ExtractFileName(ConvertSlashes(DownloadedFileName));
    DownloadedFileName := GetTempDirectory + DownloadedFileName;
    if (State = dsDownloaded) and FileExists(FileDownload.FileName) and FileExists(DownloadedFileName) and (FileDownload.PartExt <> '') then
      DeleteFile(DownloadedFileName); // delete old version
    if (State = dsAlreadyExist) or ((State = dsDownloaded) and (not FileExists(FileDownload.FileName) or RenameFile(FileDownload.FileName, DownloadedFileName))) then
    begin
      //extract
      ExtractedFileName := GetTempDirectory + FileName;
      Extracted := ExtractFile(DownloadedFileName, ExtractedFileName);
      if Extracted then
      begin
        FalconVersion := FraUpdate.SiteVersion;
        Stage := uwInstall;
        FraUpdate.LblDesc.Caption := STR_FRM_UPD[25];
        LblAction.Caption := STR_FRM_UPD[25];
        while IsAppOpen('TFrmFalconMain') do
        begin
          I := MessageBox(Handle, PChar(STR_FRM_UPD[4]),
            PChar(STR_FRM_UPD[1]), MB_YESNOCANCEL+MB_ICONWARNING);
          if I <> IDYES then
          begin
            FraUpdate.LblDesc.Caption := STR_FRM_UPD[5];
            LblAction.Caption := STR_FRM_UPD[5];
            BtnCancel.Caption := STR_FRM_UPD[22];
            Exit;
          end
          else
          begin
            BringUpApp('TFrmFalconMain');
            SendMessage(FindWindow(PChar('TFrmFalconMain'), nil), WM_CLOSE, 0, 0);
            Sleep(500);
            Application.ProcessMessages;
          end;
        end;
        //install zip file
        DeleteFile(DownloadedFileName);
        Executor.ExecuteAndWatch(ExtractedFileName, '/S',
          ExtractFilePath(ExtractedFileName), False, INFINITE,
          ExecutorInstallFinish);
      end
      else
      begin
        FraUpdate.LblDesc.Caption := STR_FRM_UPD[9];
        LblAction.Caption := STR_FRM_UPD[10];
        BtnUpdate.Caption := STR_FRM_UPD[3];
        BtnUpdate.Show;
        BtnCancel.Caption := STR_FRM_UPD[22];
        Stage := uwDownload;
      end;
    end
    else
    begin
      LblAction.Caption := STR_FRM_UPD[5];
      FraUpdate.PrgsUpdate.Hide;
      FraUpdate.MemoChanges.Hide;
      FraUpdate.LblChanges.Hide;
      FraUpdate.LblDesc.Caption := STR_FRM_UPD[6];
      BtnCancel.Caption := STR_FRM_UPD[22];
    end;
  end;
end;

procedure TFrmUpdate.FileDownloadProgress(Sender: TObject; ReceivedBytes,
  CalculatedFileSize: Cardinal);
begin
  if FraUpdate.PrgsUpdate.Tag = 1 then
  begin
    FraUpdate.PrgsUpdate.Tag := 0;
    SetProgsType(FraUpdate.PrgsUpdate, False);
  end;
  FraUpdate.PrgsUpdate.Max := CalculatedFileSize;
  FraUpdate.PrgsUpdate.Position := ReceivedBytes;
  if CalculatedFileSize > 0 then
  begin
    FraUpdate.LblDesc.Caption := FormatFloat(STR_FRM_UPD[11],
      ReceivedBytes*100/CalculatedFileSize);
  end;
end;

procedure TFrmUpdate.FileDownloadStart(Sender: TObject);
begin
  FraUpdate.PrgsUpdate.Show;
  FraUpdate.PrgsUpdate.Tag := 1;
  SetProgsType(FraUpdate.PrgsUpdate, True);//undefined time
  BtnUpdate.Hide;
  BtnCancel.Caption := STR_FRM_UPD[24];
  FraUpdate.LblDesc.Caption := STR_FRM_UPD[12];
  LblAction.Caption := STR_FRM_UPD[13];
  WriteIniFile('Update', 'LastTry', VersionToStr(FraUpdate.SiteVersion));
end;

procedure TFrmUpdate.FormShow(Sender: TObject);
begin
  if (Stage = uwDownload) then
    if BtnUpdate.Visible and BtnUpdate.Enabled then
      BtnUpdate.SetFocus;
  if Install then
    BtnCancel.SetFocus;
end;

end.
