program Falcon;

uses
  Windows,
  Forms,
  Classes,
  SendData,
  UFrmMain in 'UFrmMain.pas' {FrmFalconMain},
  UConfig in 'UConfig.pas',
  UFrmSobre in 'UFrmSobre.pas' {frmSobre},
  UFrmNew in 'UFrmNew.pas' {FrmNewProj},
  UFrmProperty in 'UFrmProperty.pas' {FrmProperty},
  UFrmCompOptions in 'UFrmCompOptions.pas' {FrmCompOptions},
  UFraProjs in 'UFraProjs.pas' {FraProjs: TFrame},
  UFraNewOpt in 'UFraNewOpt.pas' {FraPrjOpt: TFrame},
  UUtils in 'UUtils.pas',
  ExecWait in 'ExecWait.pas',
  UTemplates in 'UTemplates.pas',
  ULanguages in 'ULanguages.pas',
  UTools in 'UTools.pas',
  UFrmRemove in 'UFrmRemove.pas' {FrmRemove},
  UParseMsgs in 'UParseMsgs.pas',
  UFrmUpdate in 'UFrmUpdate.pas' {FrmUpdate},
  UFileProperty in 'UFileProperty.pas',
  UFrmEnvOptions in 'UFrmEnvOptions.pas' {FrmEnvOptions},
  UFrmEditorOptions in 'UFrmEditorOptions.pas' {FrmEditorOptions},
  UFrmReport in 'UFrmReport.pas' {FrmReport},
  UFrmFind in 'UFrmFind.pas' {FrmFind},
  FalconConst in 'FalconConst.pas',
  UFrmPromptCodeTemplate in 'UFrmPromptCodeTemplate.pas' {FrmPromptCodeTemplate},
  UFrmCodeTemplates in 'UFrmCodeTemplates.pas' {FrmCodeTemplates},
  Makefile in 'Makefile.pas',
  AStyle in '..\others\astyle\AStyle.pas',
  BZip2 in '..\others\bzip2\BZip2.pas',
  LibTar in '..\others\libtar\LibTar.pas',
  SciZipFile in '..\others\scizipfile\SciZipFile.pas',
  CompressUtils in '..\others\compressutils\CompressUtils.pas',
  StrMatch in '..\others\compressutils\StrMatch.pas',
  BreakPoint in 'Breakpoint.pas',
  CommandQueue in '..\others\debug\CommandQueue.pas',
  DebugConsts in '..\others\debug\DebugConsts.pas',
  DebugReader in '..\others\debug\DebugReader.pas',
  CppParser in '..\others\cppparser\CppParser.pas',
  ThreadLoadTokenFiles in '..\others\cppparser\ThreadLoadTokenFiles.pas',
  ThreadTokenFiles in '..\others\cppparser\ThreadTokenFiles.pas',
  TokenConst in '..\others\cppparser\TokenConst.pas',
  TokenFile in '..\others\cppparser\TokenFile.pas',
  TokenHint in '..\others\cppparser\TokenHint.pas',
  TokenList in '..\others\cppparser\TokenList.pas',
  TokenUtils in '..\others\cppparser\TokenUtils.pas',
  regexp_tregexpr in '..\others\regexp\regexp_tregexpr.pas',
  UFrmGotoFunction in 'UFrmGotoFunction.pas' {FormGotoFunction},
  UFrmGotoLine in 'UFrmGotoLine.pas' {FormGotoLine};

{$R *.res}

function OpenWithOther: Boolean;
var
  SendDT: TSendData;
  Handle, AppHandle: HWND;
  I: Integer;
  List: TStrings;
  Ms: TMemoryStream;
begin
  Result := False;
  if (ParamCount = 0) then Exit;

  Handle := FindWindow('TFrmFalconMain', nil);
  if (Handle = 0) then Exit;
  AppHandle := FindWindow('TApplication', 'Falcon C++');
  ForceForegroundWindow(Handle);
  if (AppHandle > 0) and IsIconic(AppHandle) then
    ShowWindow(AppHandle, SW_RESTORE);
  SendDT := TSendData.Create(nil);
  SendDT.ClassNamed := 'TFrmFalconMain';
  SendDT.SendType := stSend;
  List := TStringList.Create;
  Ms:= TMemoryStream.Create;
  for I:= 1 to ParamCount do
  begin
    List.Add(ParamStr(I));
  end;
  List.SaveToStream(Ms);
  List.Free;
  SendDT.SendStream(Ms);
  Ms.Free;
  SendDT.Free;
  Result := True;
end;


begin
  if OpenWithOther then Exit;
  Application.Initialize;
  Application.Title := 'Falcon C++';
  Application.CreateForm(TFrmFalconMain, FrmFalconMain);
  Application.CreateForm(TfrmSobre, frmSobre);
  Application.Run;
end.
