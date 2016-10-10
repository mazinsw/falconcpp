program Falcon;

{$I Falcon.inc}

{ Reduce EXE size by disabling as much of RTTI as possible (delphi 2009/2010) }
{$IF CompilerVersion >= 21.0}
{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$IFEND}
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
  ExecWait in '..\others\utils\ExecWait.pas',
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
  LibTar in '..\others\libtar\LibTar.pas',
  CompressUtils in '..\others\compressutils\CompressUtils.pas',
  StrMatch in '..\others\compressutils\StrMatch.pas',
  Breakpoint in 'Breakpoint.pas',
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
  icoformat in '..\others\icoformat\icoformat.pas',
  KAZip in '..\others\zip\KAZip.pas',
  UEditor in 'UEditor.pas',
  Highlighter in 'editor\Highlighter.pas',
  CppHighlighter in 'editor\CppHighlighter.pas',
  CustomColors in 'editor\CustomColors.pas',
  SintaxList in 'editor\SintaxList.pas',
  UnicodeUtils in 'editor\UnicodeUtils.pas',
  AutoComplete in 'editor\AutoComplete.pas',
  CppTokenizer in '..\others\cppparser\CppTokenizer.pas',
  CompletionProposal in 'editor\CompletionProposal.pas',
  AStyle in '..\others\astyle\wrapper\AStyle.pas',
  Big5Freq in '..\others\encoding\chsdet\src\Big5Freq.pas',
  CharDistribution in '..\others\encoding\chsdet\src\CharDistribution.pas',
  chsdIntf in '..\others\encoding\chsdet\src\chsdIntf.pas',
  CustomDetector in '..\others\encoding\chsdet\src\CustomDetector.pas',
  Dump in '..\others\encoding\chsdet\src\Dump.pas',
  EUCKRFreq in '..\others\encoding\chsdet\src\EUCKRFreq.pas',
  EUCSampler in '..\others\encoding\chsdet\src\EUCSampler.pas',
  EUCTWFreq in '..\others\encoding\chsdet\src\EUCTWFreq.pas',
  GB2312Freq in '..\others\encoding\chsdet\src\GB2312Freq.pas',
  JISFreq in '..\others\encoding\chsdet\src\JISFreq.pas',
  JpCntx in '..\others\encoding\chsdet\src\JpCntx.pas',
  MBUnicodeMultiProber in '..\others\encoding\chsdet\src\MBUnicodeMultiProber.pas',
  MultiModelProber in '..\others\encoding\chsdet\src\MultiModelProber.pas',
  nsCodingStateMachine in '..\others\encoding\chsdet\src\nsCodingStateMachine.pas',
  nsCore in '..\others\encoding\chsdet\src\nsCore.pas',
  nsEscCharsetProber in '..\others\encoding\chsdet\src\nsEscCharsetProber.pas',
  nsGroupProber in '..\others\encoding\chsdet\src\nsGroupProber.pas',
  nsHebrewProber in '..\others\encoding\chsdet\src\nsHebrewProber.pas',
  nsLatin1Prober in '..\others\encoding\chsdet\src\nsLatin1Prober.pas',
  nsMBCSMultiProber in '..\others\encoding\chsdet\src\nsMBCSMultiProber.pas',
  nsPkg in '..\others\encoding\chsdet\src\nsPkg.pas',
  nsSBCharSetProber in '..\others\encoding\chsdet\src\nsSBCharSetProber.pas',
  nsSBCSGroupProber in '..\others\encoding\chsdet\src\nsSBCSGroupProber.pas',
  nsUniversalDetector in '..\others\encoding\chsdet\src\nsUniversalDetector.pas',
  LangBulgarianModel in '..\others\encoding\chsdet\src\sbseq\LangBulgarianModel.pas',
  LangCyrillicModel in '..\others\encoding\chsdet\src\sbseq\LangCyrillicModel.pas',
  LangGreekModel in '..\others\encoding\chsdet\src\sbseq\LangGreekModel.pas',
  LangHebrewModel in '..\others\encoding\chsdet\src\sbseq\LangHebrewModel.pas',
  vi in '..\others\encoding\chsdet\src\vi.pas',
  SystemUtils in '..\others\utils\SystemUtils.pas',
  SearchEngine in 'editor\SearchEngine.pas',
  RCHighlighter in 'editor\RCHighlighter.pas',
  AppConst in 'AppConst.pas',
  CompilerSettings in 'settings\CompilerSettings.pas',
  StyleExporter in 'editor\StyleExporter.pas',
  ExporterHTML in 'editor\ExporterHTML.pas',
  ExporterRTF in 'editor\ExporterRTF.pas',
  EditorPrint in 'editor\EditorPrint.pas',
  ExporterTeX in 'editor\ExporterTeX.pas';

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

{$R resources.RES}

begin
  if OpenWithOther then
    Exit;
  Application.Initialize;
  Application.Title := 'Falcon C++';
  Application.CreateForm(TFrmFalconMain, FrmFalconMain);
  Application.Run;
end.

