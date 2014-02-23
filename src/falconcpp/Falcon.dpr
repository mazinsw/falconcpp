program Falcon;

uses
  FastMM4 in '..\others\fastmm\FastMM4.pas',
  FastMM4Messages in '..\others\fastmm\FastMM4Messages.pas',
  Windows,
  Forms,
  Classes,
  SendData,
  UFrmMain in 'UFrmMain.pas' {FrmFalconMain},
  UConfig in 'UConfig.pas',
  UFrmAbout in 'UFrmAbout.pas' {FormAbout},
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
  USourceFile in 'USourceFile.pas',
  UFrmEnvOptions in 'UFrmEnvOptions.pas' {FrmEnvOptions},
  UFrmEditorOptions in 'UFrmEditorOptions.pas' {FrmEditorOptions},
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
  ThreadTokenFiles in '..\others\cppparser\ThreadTokenFiles.pas',
  TokenConst in '..\others\cppparser\TokenConst.pas',
  TokenFile in '..\others\cppparser\TokenFile.pas',
  TokenHint in '..\others\cppparser\TokenHint.pas',
  TokenList in '..\others\cppparser\TokenList.pas',
  TokenUtils in '..\others\cppparser\TokenUtils.pas',
  UFrmGotoFunction in 'UFrmGotoFunction.pas' {FormGotoFunction},
  UFrmGotoLine in 'UFrmGotoLine.pas' {FormGotoLine},
  HintTree in '..\others\hinttree\HintTree.pas',
  DebugWatch in '..\others\debug\DebugWatch.pas',
  FastcodePatch in '..\others\nativehint\FastcodePatch.pas',
  NativeHintWindow in '..\others\nativehint\NativeHintWindow.pas',
  rbtree in 'rbtree.pas',
  CodeTemplate in 'CodeTemplate.pas',
  UFrmVisualCppOptions in 'UFrmVisualCppOptions.pas' {FrmVisualCppOptions},
  PluginManager in '..\others\plugins\PluginManager.pas',
  PluginConst in '..\others\plugins\PluginConst.pas',
  PluginUtils in '..\others\plugins\PluginUtils.pas',
  Plugin in '..\others\plugins\Plugin.pas',
  PluginServiceManager in '..\others\plugins\PluginServiceManager.pas',
  PluginWidgetMap in '..\others\plugins\PluginWidgetMap.pas',
  PluginWidget in '..\others\plugins\PluginWidget.pas',
  icoformat in '..\others\icoformat\icoformat.pas';

function OpenWithOther: Boolean;
var
  SendDT: TSendData;
  I: Integer;
  List: TStrings;
  Ms: TMemoryStream;
begin
  Result := False;
  if (ParamCount = 0) or not BringUpApp('TFrmFalconMain') then
    Exit;
  SendDT := TSendData.Create(nil);
  SendDT.ClassNamed := 'TFrmFalconMain';
  SendDT.SendType := stSend;
  List := TStringList.Create;
  Ms := TMemoryStream.Create;
  for I := 1 to ParamCount do
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
  if OpenWithOther then
    Exit;
  Application.Initialize;
  Application.Title := 'Falcon C++';
  Application.CreateForm(TFrmFalconMain, FrmFalconMain);
  Application.Run;
end.

