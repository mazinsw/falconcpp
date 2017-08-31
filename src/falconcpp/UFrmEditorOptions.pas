unit UFrmEditorOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons,
  Highlighter, CppHighlighter, UEditor, SintaxList, DScintillaTypes;

type
  TFrmEditorOptions = class(TForm)
    PageControl1: TPageControl;
    BtnOk: TButton;
    BtnCancel: TButton;
    BtnApply: TButton;
    TSGeneral: TTabSheet;
    TSDisplay: TTabSheet;
    TSSintax: TTabSheet;
    TSCodeResources: TTabSheet;
    GroupBox1: TGroupBox;
    ChbAutoIndt: TCheckBox;
    ChbUseTabChar: TCheckBox;
    ChbTabUnOrIndt: TCheckBox;
    ChbInsMode: TCheckBox;
    ChbGrpUnd: TCheckBox;
    GroupBox5: TGroupBox;
    ChbShowgtt: TCheckBox;
    ChbShowRMrgn: TCheckBox;
    Label7: TLabel;
    CboRMrg: TComboBox;
    PanelTest: TPanel;
    Label9: TLabel;
    CboSize: TComboBox;
    CboEditFont: TComboBox;
    Label10: TLabel;
    Label11: TLabel;
    GroupBox6: TGroupBox;
    ChbBold: TCheckBox;
    ChbItalic: TCheckBox;
    ChbUnderl: TCheckBox;
    Label12: TLabel;
    CbDefSin: TComboBox;
    BtnSave: TSpeedButton;
    BtnDel: TSpeedButton;
    ListBoxType: TListBox;
    Label13: TLabel;
    Label14: TLabel;
    ClbFore: TColorBox;
    Label15: TLabel;
    ClbBack: TColorBox;
    Label16: TLabel;
    CboTabWdt: TComboBox;
    ChbShowLnNumb: TCheckBox;
    ChbSmartTabs: TCheckBox;
    GroupBox8: TGroupBox;
    ChbCodeCompletion: TCheckBox;
    ChbCodeParameters: TCheckBox;
    ChbTooltipSymbol: TCheckBox;
    ChbTooltopexev: TCheckBox;
    LblDelay: TLabel;
    TrackBarCodeRes: TTrackBar;
    LblSecStart: TLabel;
    LblSecEnd: TLabel;
    TimerNormalDelay: TTimer;
    GroupBox9: TGroupBox;
    ClbCompListConst: TColorBox;
    Label17: TLabel;
    Label18: TLabel;
    ClbCompListFunc: TColorBox;
    Label19: TLabel;
    ClbCompListVar: TColorBox;
    Label20: TLabel;
    ClbCompListType: TColorBox;
    ClbCompListPreproc: TColorBox;
    Label21: TLabel;
    Label22: TLabel;
    ClbCompListBg: TColorBox;
    ClbCompListSel: TColorBox;
    Label23: TLabel;
    Label24: TLabel;
    ClbCompListTypedef: TColorBox;
    GroupBox7: TGroupBox;
    EditCodeTemplate: TEdit;
    OpenDialog: TOpenDialog;
    Label25: TLabel;
    BtnEditCodeTemplate: TSpeedButton;
    BtnChooseCodeTemplate: TSpeedButton;
    ChbEnhHomeKey: TCheckBox;
    ChbShowSpaceChars: TCheckBox;
    BtnRestDef: TButton;
    Button1: TButton;
    TSFormatter: TTabSheet;
    PageControl2: TPageControl;
    TSFormatterStyle: TTabSheet;
    TSFormatterIndentation: TTabSheet;
    TSFormatterFormatting: TTabSheet;
    GroupBoxFormatterSample: TGroupBox;
    RadioGroupFormatterStyles: TRadioGroup;
    BtnPrevStyle: TButton;
    CheckBoxForceUsingTabs: TCheckBox;
    CheckBoxIndentClasses: TCheckBox;
    CheckBoxIndentSwitches: TCheckBox;
    CheckBoxIndentCase: TCheckBox;
    CheckBoxIndentBrackets: TCheckBox;
    CheckBoxIndentBlocks: TCheckBox;
    CheckBoxIndentNamespaces: TCheckBox;
    CheckBoxIndentLabels: TCheckBox;
    CheckBoxIndentMultLinePreprocessor: TCheckBox;
    CheckBoxBreakClosingHeadersBrackets: TCheckBox;
    CheckBoxBreakElseIf: TCheckBox;
    CheckBoxDontBreakComplex: TCheckBox;
    CheckBoxDontBreakOneLineBlocks: TCheckBox;
    CheckBoxConvToSpaces: TCheckBox;
    CheckBoxIndentSingleLineComments: TCheckBox;
    CheckBoxAddBrackets: TCheckBox;
    CheckBoxAddOneLineBrackets: TCheckBox;
    TSFormatterPadding: TTabSheet;
    CheckBoxPadEmptyLines: TCheckBox;
    CheckBoxInsertSpacePaddingOperators: TCheckBox;
    CheckBoxInsertSpacePaddingParenthesisOutside: TCheckBox;
    CheckBoxInsertSpacePaddingParenthesisInside: TCheckBox;
    CheckBoxRemoveExtraSpace: TCheckBox;
    CheckBoxFillEmptyLines: TCheckBox;
    CheckBoxDeleteEmptyLines: TCheckBox;
    CheckBoxParenthesisHeaderPadding: TCheckBox;
    CheckBoxBreakClosingHeaderBlocks: TCheckBox;
    Label26: TLabel;
    ComboBoxPointerAlign: TComboBox;
    ChbAutoCloseBrackets: TCheckBox;
    Label1: TLabel;
    CboDefEnc: TComboBox;
    Label2: TLabel;
    CboDefLineEnd: TComboBox;
    ChbWithBOM: TCheckBox;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CbDefSinSelect(Sender: TObject);
    procedure ListBoxTypeClick(Sender: TObject);
    procedure StyleChangeClick(Sender: TObject);
    procedure ColorChange(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnApplyClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure CboEditFontSelect(Sender: TObject);
    procedure CboSizeChange(Sender: TObject);
    procedure SynPrevGutterClick(ASender: TObject;
      AModifiers: Integer; APosition: Integer; AMargin: Integer);
    procedure EditorOptionsChanged(Sender: TObject);
    procedure TrackBarCodeResChange(Sender: TObject);
    procedure TimerNormalDelayTimer(Sender: TObject);
    procedure BtnChooseCodeTemplateClick(Sender: TObject);
    procedure BtnEditCodeTemplateClick(Sender: TObject);
    procedure GroupEnableBoxDisableControls(Sender: TObject);
    procedure EditCodeTemplateChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BtnRestDefClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RadioGroupFormatterStylesClick(Sender: TObject);
    procedure BtnPrevStyleClick(Sender: TObject);
    procedure ComboBoxPointerAlignChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CboDefEncSelect(Sender: TObject);
  private
    { Private declarations }
    ActiveSintax: TSintax;
    Last: Integer;
    Loading: Boolean;
    EditPreview: TEditor;
    EditFormatter: TEditor;
    SynCpp: TCppHighlighter;
    procedure OptionsChange;
    procedure PositionChanged(Position: Integer);
    procedure SynPrevUpdateUI(Sender: TObject; AUpdated: Integer);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    procedure UpdateLangNow;
    procedure Load;
  end;

var
  FrmEditorOptions: TFrmEditorOptions;

implementation

uses UFrmMain, UUtils, UConfig, TokenUtils, UFrmCodeTemplates, AStyle,
  ULanguages;

{$R *.dfm}


{TFrmEditorOptions}

procedure TFrmEditorOptions.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if ParentWindow <> 0 then
  begin
    Params.Style := Params.Style and not WS_CHILD;
    if BorderStyle = bsNone then
      Params.Style := Params.Style or WS_POPUP;
  end;
end;

procedure TFrmEditorOptions.FormCreate(Sender: TObject);
begin
  Loading := True;
  SynCpp := TCppHighlighter.Create(Self);
  EditPreview := TEditor.Create(TSSintax);
  EditPreview.Parent := TSSintax;
  EditPreview.Left := ListBoxType.Left;
  EditPreview.Top := ListBoxType.Top + ListBoxType.Height + ListBoxType.Left;
  EditPreview.Width := TSSintax.Width - 2 * ListBoxType.Left;
  EditPreview.Height := TSSintax.Height - EditPreview.Top - ListBoxType.Left;
  EditPreview.TabOrder := 5;
  EditPreview.ShowLineNumber := True;
  EditPreview.HideSelection(False);
  EditPreview.Highlighter := SynCpp;
  EditPreview.ImageList := FrmFalconMain.ImageListGutter;
  EditPreview.Lines.Text :=
    '// Single line comment'#13 +
    '/// Documentation line comment'#13 +
    '#include <stdio.h>'#13 +
    '/* Multiline comment */'#13 +
    '/** @Keyword Documentation comment */'#13 +
    'int main(int argc, char *argv[]) {'#13 +
    '    int name[10] = "Falcon C++";'#13 +
    '    // Breakpoint'#13 +
    '    // Execution Point'#13 +   
    '    name[0] = ''F'';'#13 +
    '    return ''C'';'#13 +
    '}';
  EditPreview.ReadOnly := True;
  EditPreview.OnMarginClick := SynPrevGutterClick;
  EditPreview.OnUpdateUI := SynPrevUpdateUI;

  // GroupBoxFormatterSample
  EditFormatter := TEditor.Create(GroupBoxFormatterSample);
  EditFormatter.Parent := GroupBoxFormatterSample;
  EditFormatter.Align := alClient;
  EditFormatter.TabOrder := 0;
  EditFormatter.ShowLineNumber := False;
  EditFormatter.HideSelection(False);
  EditFormatter.Highlighter := SynCpp;
  EditFormatter.Lines.Text :=
    'namespace foospace'#13 +
    '{'#13 +
    '    int Foo()'#13 +
    '    {'#13 +
    '        if (isBar)'#13 +
    '        {'#13 +
    '            bar();'#13 +
    '            return 1;'#13 +
    '        }'#13 +
    '        else'#13 +
    '            return 0;'#13 +
    '    }'#13 +
    '}';

  CboEditFont.Items.AddStrings(Screen.Fonts);
  ActiveSintax := TSintax.Create;
  UpdateLangNow;
  Loading := False;
end;

procedure TFrmEditorOptions.Load;
var
  I: Integer;
  Stx: TSintax;
begin
  Loading := True;
  CboEditFont.ItemIndex := CboEditFont.Items.IndexOf(Font.Name);
  LoadFontSize(Font.Name, CboSize.Items);

  CbDefSin.Clear;
  for I := 0 to FrmFalconMain.SintaxList.Count - 1 do
  begin
    Stx := FrmFalconMain.SintaxList.Items[I];
    CbDefSin.AddItem(Stx.Name, Stx);
  end;
  CbDefSin.ItemIndex := FrmFalconMain.SintaxList.ItemIndex;
  CbDefSinSelect(Self);

  with FrmFalconMain.Config.Editor do
  begin
    //--------------General---------------------//
    ChbAutoIndt.Checked := AutoIndent;
    ChbInsMode.Checked := InsertMode;
    ChbGrpUnd.Checked := GroupUndo;

    ChbTabUnOrIndt.Checked := TabIndentUnindent;
    ChbSmartTabs.Checked := SmartTabs;
    ChbUseTabChar.Checked := UseTabChar;
    ChbEnhHomeKey.Checked := EnhancedHomeKey;
    ChbShowSpaceChars.Checked := ShowSpaceChars;
    ChbAutoCloseBrackets.Checked := AutoCloseBrackets;

    CboTabWdt.Text := IntToStr(TabWidth);
    CboDefEnc.ItemIndex := DefaultEncoding;
    ChbWithBOM.Checked := EncodingWithBOM;
    CboDefEncSelect(CboDefEnc);
    CboDefLineEnd.ItemIndex := DefaultLineEnding;

    //---------------- Display -----------------//
    CboEditFont.Text := FontName;
    CboEditFontSelect(Self);
    CboSize.Text := IntToStr(FontSize);
    CboSizeChange(Self);
    ChbShowRMrgn.Checked := ShowRightMargin;
    CboRMrg.Text := IntToStr(RightMargin);
    ChbShowgtt.Checked := ShowGutter;
    ChbShowLnNumb.Checked := ShowLineNumber;
    //---------------- Colors ------------------//

    //Formatter
      //Style
    RadioGroupFormatterStyles.ItemIndex := StyleIndex;
    BtnPrevStyle.Visible := RadioGroupFormatterStyles.ItemIndex = RadioGroupFormatterStyles.Items.Count - 1;
    for I := 0 to TSFormatterIndentation.ControlCount - 1 do
    begin
      TSFormatterIndentation.Controls[I].Enabled := BtnPrevStyle.Visible;
    end;
    for I := 0 to TSFormatterPadding.ControlCount - 1 do
    begin
      TSFormatterPadding.Controls[I].Enabled := BtnPrevStyle.Visible;
    end;
    for I := 0 to TSFormatterFormatting.ControlCount - 1 do
    begin
      TSFormatterFormatting.Controls[I].Enabled := BtnPrevStyle.Visible;
    end;
      //Indentation
    CheckBoxForceUsingTabs.Checked := ForceUsingTabs;
    CheckBoxIndentClasses.Checked := IndentClasses;
    CheckBoxIndentSwitches.Checked := IndentSwitches;
    CheckBoxIndentCase.Checked := IndentCase;
    CheckBoxIndentBrackets.Checked := IndentBrackets;
    CheckBoxIndentBlocks.Checked := IndentBlocks;
    CheckBoxIndentNamespaces.Checked := IndentNamespaces;
    CheckBoxIndentLabels.Checked := IndentLabels;
    CheckBoxIndentMultLinePreprocessor.Checked := IndentMultLine;
    CheckBoxIndentSingleLineComments.Checked := IndentSingleLineComments;
      //Padding
    CheckBoxPadEmptyLines.Checked := PadEmptyLines;
    CheckBoxBreakClosingHeaderBlocks.Checked := BreakClosingHeaderBlocks;
    CheckBoxInsertSpacePaddingOperators.Checked := InsertSpacePaddingOperators;
    CheckBoxInsertSpacePaddingParenthesisOutside.Checked :=
      InsertSpacePaddingParenthesisOutside;
    CheckBoxInsertSpacePaddingParenthesisInside.Checked :=
      InsertSpacePaddingParenthesisInside;
    CheckBoxParenthesisHeaderPadding.Checked := ParenthesisHeaderPadding;
    CheckBoxRemoveExtraSpace.Checked := RemoveExtraSpace;
    CheckBoxDeleteEmptyLines.Checked := DeleteEmptyLines;
    CheckBoxFillEmptyLines.Checked := FillEmptyLines;
      //Formatting
    CheckBoxBreakClosingHeadersBrackets.Checked := BreakClosingHeadersBrackets;
    CheckBoxBreakElseIf.Checked := BreakIfElse;
    CheckBoxAddBrackets.Checked := AddBrackets;
    CheckBoxAddOneLineBrackets.Checked := AddOneLineBrackets;
    CheckBoxDontBreakOneLineBlocks.Checked := DontBreakOnelineBlocks;
    CheckBoxDontBreakComplex.Checked := DontBreakComplex;
    CheckBoxConvToSpaces.Checked := ConvertTabToSpaces;
    ComboBoxPointerAlign.ItemIndex := PointerAlign;
    //---------------- Code Resources ------------------//
    ChbCodeCompletion.Checked := CodeCompletion;
    ChbCodeParameters.Checked := CodeParameters;
    ChbTooltopexev.Checked := TooltipExpEval;
    ChbTooltipSymbol.Checked := TooltipSymbol;
    TrackBarCodeRes.Position := CodeDelay - 1;

    ClbCompListConst.Selected := CompListConstant;
    ClbCompListFunc.Selected := CompListFunc;
    ClbCompListVar.Selected := CompListVar;
    ClbCompListType.Selected := CompListType;

    ClbCompListTypedef.Selected := CompListTypedef;
    ClbCompListPreproc.Selected := CompListPreproc;
    ClbCompListSel.Selected := CompListSel;
    ClbCompListBg.Selected := CompListBg;

    EditCodeTemplate.Text := CodeTemplateFile;
  end;
  EditPreview.AddBreakpoint(8);
  EditPreview.SetActiveLine(9);
  Loading := False;
end;

procedure TFrmEditorOptions.BtnApplyClick(Sender: TObject);
begin
  BtnApply.Enabled := False;
  ActiveSintax.UpdateHighlight(FrmFalconMain.CppHighligher);
  with FrmFalconMain.Config.Editor do
  begin
    //------------- General ----------------------//
    AutoIndent := ChbAutoIndt.Checked;
    InsertMode := ChbInsMode.Checked;
    GroupUndo := ChbGrpUnd.Checked;

    TabIndentUnindent := ChbTabUnOrIndt.Checked;
    SmartTabs := ChbSmartTabs.Checked;
    UseTabChar := ChbUseTabChar.Checked;
    EnhancedHomeKey := ChbEnhHomeKey.Checked;
    ShowSpaceChars := ChbShowSpaceChars.Checked;
    AutoCloseBrackets := ChbAutoCloseBrackets.Checked;

    TabWidth := StrToIntDef(CboTabWdt.Text, 4);
    DefaultEncoding := CboDefEnc.ItemIndex;
    if DefaultEncoding < 0 then
      DefaultEncoding := 0;
    EncodingWithBOM := ChbWithBOM.Checked;
    DefaultLineEnding := CboDefLineEnd.ItemIndex;
    if DefaultLineEnding < 0 then
      DefaultLineEnding := 0;
    //---------------- Display -----------------//
    FontName := CboEditFont.Text;
    FontSize := StrToIntDef(CboSize.Text, 10);
    ShowRightMargin := ChbShowRMrgn.Checked;
    RightMargin := StrToIntDef(CboRMrg.Text, 80);
    ShowGutter := ChbShowgtt.Checked;
    ShowLineNumber := ChbShowLnNumb.Checked;
    //---------------- Colors ------------------//
    if (CbDefSin.Items.IndexOf(CbDefSin.Text) < 0) or Self.ActiveSintax.Changed then
      BtnSave.Click;
    FrmFalconMain.SintaxList.ItemIndex := CbDefSin.ItemIndex;
    ActiveSintax := CbDefSin.Text;
    //--------------  formatter  ---------------//
    StyleIndex := RadioGroupFormatterStyles.ItemIndex;
    //Indentation
    ForceUsingTabs := CheckBoxForceUsingTabs.Checked;
    IndentClasses := CheckBoxIndentClasses.Checked;
    IndentSwitches := CheckBoxIndentSwitches.Checked;
    IndentCase := CheckBoxIndentCase.Checked;
    IndentBrackets := CheckBoxIndentBrackets.Checked;
    IndentBlocks := CheckBoxIndentBlocks.Checked;
    IndentNamespaces := CheckBoxIndentNamespaces.Checked;
    IndentLabels := CheckBoxIndentLabels.Checked;
    IndentMultLine := CheckBoxIndentMultLinePreprocessor.Checked;
    IndentSingleLineComments := CheckBoxIndentSingleLineComments.Checked;
    //Padding
    PadEmptyLines := CheckBoxPadEmptyLines.Checked;
    BreakClosingHeaderBlocks := CheckBoxBreakClosingHeaderBlocks.Checked;
    InsertSpacePaddingOperators := CheckBoxInsertSpacePaddingOperators.Checked;
    InsertSpacePaddingParenthesisOutside :=
      CheckBoxInsertSpacePaddingParenthesisOutside.Checked;
    InsertSpacePaddingParenthesisInside :=
      CheckBoxInsertSpacePaddingParenthesisInside.Checked;
    ParenthesisHeaderPadding := CheckBoxParenthesisHeaderPadding.Checked;
    RemoveExtraSpace := CheckBoxRemoveExtraSpace.Checked;
    DeleteEmptyLines := CheckBoxDeleteEmptyLines.Checked;
    FillEmptyLines := CheckBoxFillEmptyLines.Checked;
    //Formatting
    BreakClosingHeadersBrackets := CheckBoxBreakClosingHeadersBrackets.Checked;
    BreakIfElse := CheckBoxBreakElseIf.Checked;
    AddBrackets := CheckBoxAddBrackets.Checked;
    AddOneLineBrackets := CheckBoxAddOneLineBrackets.Checked;
    DontBreakOnelineBlocks := CheckBoxDontBreakOneLineBlocks.Checked;
    DontBreakComplex := CheckBoxDontBreakComplex.Checked;
    ConvertTabToSpaces := CheckBoxConvToSpaces.Checked;
    PointerAlign := ComboBoxPointerAlign.ItemIndex;
    //--------------  Code Resources  ----------//
    CodeCompletion := ChbCodeCompletion.Checked;
    CodeParameters := ChbCodeParameters.Checked;
    TooltipExpEval := ChbTooltopexev.Checked;
    TooltipSymbol := ChbTooltipSymbol.Checked;
    CodeDelay := TrackBarCodeRes.Position + 1;

    CompListConstant := ClbCompListConst.Selected;
    CompListFunc := ClbCompListFunc.Selected;
    CompListVar := ClbCompListVar.Selected;
    CompListType := ClbCompListType.Selected;
    CompListTypedef := ClbCompListTypedef.Selected;
    CompListPreproc := ClbCompListPreproc.Selected;
    CompListSel := ClbCompListSel.Selected;
    CompListBg := ClbCompListBg.Selected;

    if FileExists(EditCodeTemplate.Text) then
      CodeTemplateFile := EditCodeTemplate.Text;
  end;
  FrmFalconMain.UpdateOpenedSheets;
end;

procedure TFrmEditorOptions.BtnOkClick(Sender: TObject);
begin
  if ActiveSintax.Changed then
    BtnSave.Click;
  if CbDefSin.ItemIndex >= 0 then
    FrmFalconMain.SintaxList.ItemIndex := CbDefSin.ItemIndex;
  BtnApply.Click;
  Close;
end;

procedure TFrmEditorOptions.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #27) then
  begin
    Key := #0;
    Close;
  end;
end;

procedure TFrmEditorOptions.UpdateLangNow;
begin
  Caption := STR_FRM_EDITOR_OPT[1];
  BtnOk.Caption := STR_FRM_PROP[14];
  BtnCancel.Caption := STR_FRM_PROP[15];
  BtnApply.Caption := STR_FRM_PROP[16];
  //General
  TSGeneral.Caption := STR_FRM_EDITOR_OPT[2];
  GroupBox1.Caption := STR_FRM_EDITOR_OPT[3];
  ChbAutoIndt.Caption := STR_FRM_EDITOR_OPT[4];
  ChbInsMode.Caption := STR_FRM_EDITOR_OPT[6];
  ChbGrpUnd.Caption := STR_FRM_EDITOR_OPT[7];
  ChbShowSpaceChars.Caption := STR_FRM_EDITOR_OPT[9];
  ChbAutoCloseBrackets.Caption := STR_FRM_EDITOR_OPT[138];
  ChbTabUnOrIndt.Caption := STR_FRM_EDITOR_OPT[11];
  ChbSmartTabs.Caption := STR_FRM_EDITOR_OPT[12];
  ChbUseTabChar.Caption := STR_FRM_EDITOR_OPT[13];
  ChbEnhHomeKey.Caption := STR_FRM_EDITOR_OPT[14];
  Label16.Caption := STR_FRM_EDITOR_OPT[16];
  BtnRestDef.Caption := STR_FRM_EDITOR_OPT[24];
  //Display
  TSDisplay.Caption := STR_FRM_EDITOR_OPT[25];
  Label11.Caption := STR_FRM_EDITOR_OPT[26];
  Label9.Caption := STR_FRM_EDITOR_OPT[27];
  Label10.Caption := STR_FRM_EDITOR_OPT[28];
  GroupBox5.Caption := STR_FRM_EDITOR_OPT[29];
  ChbShowRMrgn.Caption := STR_FRM_EDITOR_OPT[30];
  ChbShowgtt.Caption := STR_FRM_EDITOR_OPT[31];
  ChbShowLnNumb.Caption := STR_FRM_EDITOR_OPT[32];
  Button1.Caption := STR_FRM_EDITOR_OPT[24];
  Label7.Caption := STR_FRM_EDITOR_OPT[34];
  TSSintax.Caption := STR_FRM_EDITOR_OPT[36];
  Label13.Caption := STR_FRM_EDITOR_OPT[37];
  Label12.Caption := STR_FRM_EDITOR_OPT[38];
  BtnSave.Hint := STR_FRM_EDITOR_OPT[39];
  BtnDel.Hint := STR_FRM_EDITOR_OPT[40];
  Label14.Caption := STR_FRM_EDITOR_OPT[41];
  Label15.Caption := STR_FRM_EDITOR_OPT[42];
  GroupBox6.Caption := STR_FRM_EDITOR_OPT[43];
  ChbBold.Caption := STR_FRM_EDITOR_OPT[44];
  ChbItalic.Caption := STR_FRM_EDITOR_OPT[45];
  ChbUnderl.Caption := STR_FRM_EDITOR_OPT[46];
  //Formatter
  TSFormatter.Caption := STR_FRM_EDITOR_OPT[48];
  //Style
  TSFormatterStyle.Caption := STR_FRM_EDITOR_OPT[49];
  RadioGroupFormatterStyles.Caption := STR_FRM_EDITOR_OPT[43];
  RadioGroupFormatterStyles.Items[RadioGroupFormatterStyles.Items.Count - 1] := STR_FRM_EDITOR_OPT[50];
  BtnPrevStyle.Caption := STR_FRM_EDITOR_OPT[51];
  GroupBoxFormatterSample.Caption := STR_FRM_EDITOR_OPT[52];
  //Indentation
  TSFormatterIndentation.Caption := STR_FRM_EDITOR_OPT[53];
  CheckBoxForceUsingTabs.Caption := STR_FRM_EDITOR_OPT[54];
  CheckBoxIndentClasses.Caption := STR_FRM_EDITOR_OPT[55];
  CheckBoxIndentSwitches.Caption := STR_FRM_EDITOR_OPT[56];
  CheckBoxIndentCase.Caption := STR_FRM_EDITOR_OPT[57];
  CheckBoxIndentBrackets.Caption := STR_FRM_EDITOR_OPT[58];
  CheckBoxIndentBlocks.Caption := STR_FRM_EDITOR_OPT[59];
  CheckBoxIndentNamespaces.Caption := STR_FRM_EDITOR_OPT[60];
  CheckBoxIndentLabels.Caption := STR_FRM_EDITOR_OPT[61];
  CheckBoxIndentMultLinePreprocessor.Caption := STR_FRM_EDITOR_OPT[62];
  CheckBoxIndentSingleLineComments.Caption := STR_FRM_EDITOR_OPT[63];
  CheckBoxForceUsingTabs.Hint := STR_FRM_EDITOR_OPT[64];
  CheckBoxIndentClasses.Hint := STR_FRM_EDITOR_OPT[65];
  CheckBoxIndentSwitches.Hint := STR_FRM_EDITOR_OPT[66];
  CheckBoxIndentCase.Hint := STR_FRM_EDITOR_OPT[67];
  CheckBoxIndentNamespaces.Hint := STR_FRM_EDITOR_OPT[68];
  CheckBoxIndentLabels.Hint := STR_FRM_EDITOR_OPT[69];
  CheckBoxIndentMultLinePreprocessor.Hint := STR_FRM_EDITOR_OPT[70];
  CheckBoxIndentSingleLineComments.Hint := STR_FRM_EDITOR_OPT[71];
  //Padding
  TSFormatterPadding.Caption := STR_FRM_EDITOR_OPT[72];
  CheckBoxPadEmptyLines.Caption := STR_FRM_EDITOR_OPT[73];
  CheckBoxBreakClosingHeaderBlocks.Caption := STR_FRM_EDITOR_OPT[74];
  CheckBoxInsertSpacePaddingOperators.Caption := STR_FRM_EDITOR_OPT[75];
  CheckBoxInsertSpacePaddingParenthesisOutside.Caption := STR_FRM_EDITOR_OPT[76];
  CheckBoxInsertSpacePaddingParenthesisInside.Caption := STR_FRM_EDITOR_OPT[77];
  CheckBoxParenthesisHeaderPadding.Caption := STR_FRM_EDITOR_OPT[78];
  CheckBoxRemoveExtraSpace.Caption := STR_FRM_EDITOR_OPT[79];
  CheckBoxDeleteEmptyLines.Caption := STR_FRM_EDITOR_OPT[80];
  CheckBoxFillEmptyLines.Caption := STR_FRM_EDITOR_OPT[81];
  CheckBoxPadEmptyLines.Hint := STR_FRM_EDITOR_OPT[82];
  CheckBoxBreakClosingHeaderBlocks.Hint := STR_FRM_EDITOR_OPT[83];
  CheckBoxInsertSpacePaddingOperators.Hint := STR_FRM_EDITOR_OPT[84];
  CheckBoxInsertSpacePaddingParenthesisOutside.Hint := STR_FRM_EDITOR_OPT[85];
  CheckBoxInsertSpacePaddingParenthesisInside.Hint := STR_FRM_EDITOR_OPT[86];
  CheckBoxParenthesisHeaderPadding.Hint := STR_FRM_EDITOR_OPT[87];
  CheckBoxRemoveExtraSpace.Hint := STR_FRM_EDITOR_OPT[88];
  CheckBoxDeleteEmptyLines.Hint := STR_FRM_EDITOR_OPT[89];
  CheckBoxFillEmptyLines.Hint := STR_FRM_EDITOR_OPT[90];
  //formatting
  TSFormatterFormatting.Caption := STR_FRM_EDITOR_OPT[91];
  CheckBoxBreakClosingHeadersBrackets.Caption := STR_FRM_EDITOR_OPT[97];
  CheckBoxBreakElseIf.Caption := STR_FRM_EDITOR_OPT[98];
  CheckBoxAddBrackets.Caption := STR_FRM_EDITOR_OPT[99];
  CheckBoxAddOneLineBrackets.Caption := STR_FRM_EDITOR_OPT[100];
  CheckBoxDontBreakOneLineBlocks.Caption := STR_FRM_EDITOR_OPT[101];
  CheckBoxDontBreakComplex.Caption := STR_FRM_EDITOR_OPT[102];
  CheckBoxConvToSpaces.Caption := STR_FRM_EDITOR_OPT[103];
  CheckBoxBreakClosingHeadersBrackets.Hint := STR_FRM_EDITOR_OPT[104];
  CheckBoxBreakElseIf.Hint := STR_FRM_EDITOR_OPT[105];
  CheckBoxAddBrackets.Hint := STR_FRM_EDITOR_OPT[106];
  CheckBoxAddOneLineBrackets.Hint := STR_FRM_EDITOR_OPT[107];
  CheckBoxDontBreakOneLineBlocks.Hint := STR_FRM_EDITOR_OPT[108];
  CheckBoxDontBreakComplex.Hint := STR_FRM_EDITOR_OPT[109];
  CheckBoxConvToSpaces.Hint := STR_FRM_EDITOR_OPT[110];
  Label26.Caption := STR_FRM_EDITOR_OPT[111];
  ComboBoxPointerAlign.Items.Strings[0] := STR_FRM_EDITOR_OPT[112];
  ComboBoxPointerAlign.Items.Strings[1] := STR_FRM_EDITOR_OPT[113];
  ComboBoxPointerAlign.Items.Strings[2] := STR_FRM_EDITOR_OPT[114];
  ComboBoxPointerAlign.Items.Strings[3] := STR_FRM_EDITOR_OPT[115];
  ComboBoxPointerAlign.Hint := STR_FRM_EDITOR_OPT[116];
  //Code Resources
  TSCodeResources.Caption := STR_FRM_EDITOR_OPT[117];
  GroupBox8.Caption := STR_FRM_EDITOR_OPT[118];
  ChbCodeCompletion.Caption := STR_FRM_EDITOR_OPT[119];
  ChbCodeParameters.Caption := STR_FRM_EDITOR_OPT[120];
  ChbTooltopexev.Caption := STR_FRM_EDITOR_OPT[121];
  ChbTooltipSymbol.Caption := STR_FRM_EDITOR_OPT[122];
  LblDelay.Caption := STR_FRM_EDITOR_OPT[123];
  GroupBox9.Caption := STR_FRM_EDITOR_OPT[125];
  Label17.Caption := STR_FRM_EDITOR_OPT[126];
  Label18.Caption := STR_FRM_EDITOR_OPT[127];
  Label19.Caption := STR_FRM_EDITOR_OPT[128];
  Label20.Caption := STR_FRM_EDITOR_OPT[129];
  Label24.Caption := STR_FRM_EDITOR_OPT[130];
  Label21.Caption := STR_FRM_EDITOR_OPT[131];
  Label23.Caption := STR_FRM_EDITOR_OPT[132];
  Label22.Caption := STR_FRM_EDITOR_OPT[133];
  GroupBox7.Caption := STR_FRM_EDITOR_OPT[134];
  Label25.Caption := STR_FRM_EDITOR_OPT[135];
  BtnChooseCodeTemplate.Hint := STR_FRM_EDITOR_OPT[136];
  BtnEditCodeTemplate.Hint := STR_FRM_EDITOR_OPT[137];
end;

procedure TFrmEditorOptions.PositionChanged(Position: Integer);
var
  AttrName: string;
  S: UnicodeString;
  attr: THighlighStyle;
  st: TSintaxType;
  I, Line: Integer;
begin
  if Position = -1 then
    AttrName := STY_PROP_GUTTER
  else
  begin
    Line := EditPreview.LineFromPosition(Position) + 1;
    if Line = 8 then
    begin
      AttrName := STY_PROP_BREAKPOINT;
    end
    else if Line = 9 then
    begin
      AttrName := STY_PROP_EXECPOINT;
    end
    else
    begin
      if not EditPreview.GetHighlighterAttriAt(Position, S, attr) then
        AttrName := HL_Style_Space
      else
        AttrName := attr.Name;
    end;
  end;
  if ActiveSintax.GetType(AttrName, st) then
  begin
    I := ActiveSintax.IndexOf(st);
    if I < 0 then
      Exit;
    ListBoxType.ItemIndex := I;
    ListBoxType.Selected[I] := True;
    ListBoxTypeClick(Self);
  end;
end;

procedure TFrmEditorOptions.SynPrevUpdateUI(Sender: TObject;
  AUpdated: Integer);
begin
  if (AUpdated and SC_UPDATE_SELECTION) <> SC_UPDATE_SELECTION then
    Exit;
  PositionChanged(EditPreview.GetCurrentPos);
end;

procedure TFrmEditorOptions.SynPrevGutterClick(ASender: TObject;
  AModifiers: Integer; APosition: Integer; AMargin: Integer);
begin
  PositionChanged(-1);
end;

procedure TFrmEditorOptions.FormDestroy(Sender: TObject);
begin
  ActiveSintax.Free;
  FrmEditorOptions := nil;
end;

procedure TFrmEditorOptions.CbDefSinSelect(Sender: TObject);
var
  I: Integer;
  StxTpy: TSintaxType;
begin
  if CbDefSin.ItemIndex < 0 then
  begin
    BtnSave.Enabled := ActiveSintax.Changed;
    BtnDel.Enabled := False;
    Exit;
  end;
  ActiveSintax.Assign(FrmFalconMain.SintaxList.Items[CbDefSin.ItemIndex]);
  BtnDel.Enabled := not ActiveSintax.ReadOnly;
  BtnSave.Enabled := ActiveSintax.Changed;
  ListBoxType.Items.Clear;
  for I := 0 to ActiveSintax.Count - 1 do
    ListBoxType.Items.Add(ActiveSintax.Items[I].Name);
  if ActiveSintax.Count = 0 then
    Exit;
  if Last >= ActiveSintax.Count then
    Last := 0;

  StxTpy := ActiveSintax.Items[Last];
  ListBoxType.ItemIndex := Last;
  ListBoxType.Selected[Last] := True;
  ClbFore.Selected := StxTpy.Foreground;
  ClbBack.Selected := StxTpy.Background;
  ChbBold.Checked := (fsBold in StxTpy.Style);
  ChbItalic.Checked := (fsItalic in StxTpy.Style);
  ChbUnderl.Checked := (fsUnderline in StxTpy.Style);
  ActiveSintax.UpdateHighlight(SynCpp);
  ActiveSintax.UpdateEditor(EditPreview);
  ActiveSintax.UpdateEditor(EditFormatter);
  OptionsChange;
end;

procedure TFrmEditorOptions.ListBoxTypeClick(Sender: TObject);
var
  StxTpy: TSintaxType;
begin
  if ListBoxType.ItemIndex = Last then
    Exit;
  Last := ListBoxType.ItemIndex;
  StxTpy := ActiveSintax.Items[Last];
  Loading := True;
  ListBoxType.ItemIndex := Last;
  ListBoxType.Selected[Last] := True;
  ClbFore.Selected := StxTpy.Foreground;
  ClbFore.Invalidate;
  ClbBack.Selected := StxTpy.Background;
  ClbBack.Invalidate;
  ChbBold.Checked := (fsBold in StxTpy.Style);
  ChbItalic.Checked := (fsItalic in StxTpy.Style);
  ChbUnderl.Checked := (fsUnderline in StxTpy.Style);
  Loading := False;
end;

procedure TFrmEditorOptions.StyleChangeClick(Sender: TObject);
var
  NewStyle: TFontStyles;
  AttrName, NewName: string;
  I: Integer;
  st: TSintaxType;
begin
  if Loading then
    Exit;
  NewStyle := [];
  if ChbBold.Checked then
    NewStyle := NewStyle + [fsBold];
  if ChbItalic.Checked then
    NewStyle := NewStyle + [fsItalic];
  if ChbUnderl.Checked then
    NewStyle := NewStyle + [fsUnderline];

  if (ListBoxType.ItemIndex < 0) then
    Exit;
  AttrName := ListBoxType.Items[ListBoxType.ItemIndex];

  if ActiveSintax.GetType(AttrName, st) then
  begin
    if st.Style = NewStyle then
      Exit;
    st.Style := NewStyle;
  end;
  BtnSave.Enabled := True;

  if (AttrName <> STY_PROP_DEFAULT) and
     (AttrName <> STY_PROP_GUTTER) and     
     (AttrName <> STY_PROP_CARETLINE) and
     (AttrName <> STY_PROP_SELECTION) and 
     (AttrName <> STY_PROP_BREAKPOINT) and
     (AttrName <> STY_PROP_EXECPOINT) and
     (AttrName <> STY_PROP_CARETCOLOR) and 
     (AttrName <> STY_PROP_BRACE) and
     (AttrName <> STY_PROP_BADBRACE) and
     (AttrName <> STY_PROP_LINKCOLOR) and
     (AttrName <> STY_PROP_SELWORD) then
  begin
    ActiveSintax.UpdateHighlight(EditPreview.Highlighter, AttrName);
  end
  else
    ActiveSintax.UpdateEditor(EditPreview, AttrName);

  if ActiveSintax.ReadOnly then
  begin
    if not ActiveSintax.Changed then
    begin
      ActiveSintax.Changed := True;
      CbDefSin.ItemIndex := -1;
      NewName := STR_FRM_EDITOR_OPT[47];
      I := 0;
      while CbDefSin.Items.IndexOf(NewName) >= 0 do
      begin
        Inc(I);
        NewName := STR_FRM_EDITOR_OPT[47] + IntToStr(I);
      end;
      CbDefSin.Text := NewName;
    end;
  end
  else
    ActiveSintax.Changed := True;
  OptionsChange;
end;

procedure TFrmEditorOptions.ColorChange(Sender: TObject);
var
  AttrName, NewName: string;
  I: Integer;
  st: TSintaxType;
begin
  if (ListBoxType.ItemIndex < 0) then
    Exit;
  AttrName := ListBoxType.Items[ListBoxType.ItemIndex];

  if ActiveSintax.GetType(AttrName, st) then
  begin
    if (st.Foreground = ClbFore.Selected) and
      (st.Background = ClbBack.Selected) then
      Exit;
    st.Foreground := ClbFore.Selected;
    st.Background := ClbBack.Selected;
  end;
  BtnSave.Enabled := True;
  if (AttrName <> STY_PROP_DEFAULT) and
     (AttrName <> STY_PROP_GUTTER) and
     (AttrName <> STY_PROP_CARETLINE) and
     (AttrName <> STY_PROP_SELECTION) and
     (AttrName <> STY_PROP_BREAKPOINT) and
     (AttrName <> STY_PROP_EXECPOINT) and
     (AttrName <> STY_PROP_CARETCOLOR) and
     (AttrName <> STY_PROP_BRACE) and
     (AttrName <> STY_PROP_BADBRACE) and
     (AttrName <> STY_PROP_LINKCOLOR) and
     (AttrName <> STY_PROP_SELWORD) then
  begin
    ActiveSintax.UpdateHighlight(EditPreview.Highlighter, AttrName);
  end
  else
  begin
    ActiveSintax.UpdateEditor(EditPreview, AttrName);
  end;
  if ActiveSintax.ReadOnly then
  begin
    if not ActiveSintax.Changed then
    begin
      ActiveSintax.Changed := True;
      CbDefSin.ItemIndex := -1;
      NewName := STR_FRM_EDITOR_OPT[47];
      I := 0;
      while CbDefSin.Items.IndexOf(NewName) >= 0 do
      begin
        Inc(I);
        NewName := STR_FRM_EDITOR_OPT[47] + IntToStr(I);
      end;
      CbDefSin.Text := NewName;
    end;
  end
  else
    ActiveSintax.Changed := True;
  OptionsChange;
end;

procedure TFrmEditorOptions.BtnSaveClick(Sender: TObject);
var
  stx: TSintax;
  Index: Integer;
  S: string;
begin
  ActiveSintax.Changed := False;
  BtnSave.Enabled := False;
  S := CbDefSin.Text;
  Index := CbDefSin.Items.IndexOf(S);
  if Index >= 0 then
  begin
    stx := FrmFalconMain.SintaxList.Items[Index];
    if not stx.ReadOnly then
      stx.Assign(ActiveSintax);
    Exit;
  end;
  stx := TSintax.Create;
  stx.Assign(ActiveSintax);
  stx.ReadOnly := False;
  stx.Name := S;
  FrmFalconMain.SintaxList.Insert(0, stx);
  CbDefSin.Items.Insert(0, S);
  CbDefSin.ItemIndex := 0;
  CbDefSinSelect(CbDefSin);
end;

procedure TFrmEditorOptions.BtnDelClick(Sender: TObject);
var
  Index: Integer;
  Equal: Boolean;
begin
  Equal := False;
  Index := CbDefSin.ItemIndex;
  if (Index < 0) or ActiveSintax.ReadOnly then
    Exit;
  with FrmFalconMain do
  begin
    SintaxList.Delete(Index);
    if Index = SintaxList.ItemIndex then
    begin
      Equal := True;
      SintaxList.ItemIndex := SintaxList.Count - 1;
      Config.Editor.ActiveSintax := SintaxList.Selected.Name;
      UpdateOpenedSheets;
    end;
  end;

  CbDefSin.Items.Delete(Index);
  if CbDefSin.Items.Count > 0 then
  begin
    if Equal then
      CbDefSin.ItemIndex := CbDefSin.Items.Count - 1
    else
      CbDefSin.ItemIndex := 0;
    CbDefSinSelect(CbDefSin);
  end;
end;

procedure TFrmEditorOptions.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmEditorOptions.OptionsChange;
begin
  if Loading then
    Exit;
  //-----------------------------//
  BtnApply.Enabled := True;
end;

procedure TFrmEditorOptions.CboDefEncSelect(Sender: TObject);
begin
  ChbWithBOM.Enabled := CboDefEnc.ItemIndex > 0;
  if CboDefEnc.ItemIndex = 0 then
    ChbWithBOM.Checked := False
  else
    ChbWithBOM.Checked := FrmFalconMain.Config.Editor.EncodingWithBOM;
end;

procedure TFrmEditorOptions.CboEditFontSelect(Sender: TObject);
var
  S: string;
begin
  if CboEditFont.ItemIndex < 0 then
    Exit;
  PanelTest.Font.Name := CboEditFont.Text;
  S := CboSize.Text;
  CboSize.Clear;
  LoadFontSize(Font.Name, CboSize.Items);
  CboSize.ItemIndex := CboSize.Items.IndexOf(S);
  if CboSize.ItemIndex < 0 then
    CboSize.Text := S;
  OptionsChange;
end;

procedure TFrmEditorOptions.CboSizeChange(Sender: TObject);
begin
  PanelTest.Font.Size := StrToIntDef(CboSize.Text, 10);
  OptionsChange;
end;

procedure TFrmEditorOptions.EditorOptionsChanged(Sender: TObject);
begin
  if Sender = ChbShowRMrgn then
  begin
    Label7.Enabled := ChbShowRMrgn.Checked;
    CboRMrg.Enabled := ChbShowRMrgn.Checked;
  end
  else if Sender = ChbShowgtt then
  begin
    ChbShowLnNumb.Enabled := ChbShowgtt.Checked;
  end
  else if Sender = CheckBoxAddOneLineBrackets then
  begin
    CheckBoxDontBreakOneLineBlocks.Enabled :=
      not CheckBoxAddOneLineBrackets.Checked;
  end
  else if Sender = CheckBoxForceUsingTabs then
  begin
    CheckBoxConvToSpaces.Enabled := not CheckBoxForceUsingTabs.Checked;
    if not CheckBoxConvToSpaces.Enabled then
      CheckBoxConvToSpaces.Checked := False;
  end;
  OptionsChange;
end;

procedure TFrmEditorOptions.TrackBarCodeResChange(Sender: TObject);
var
  S: string;
begin
  S := Format(STR_FRM_EDITOR_OPT[123] + ' ' +
    STR_FRM_EDITOR_OPT[124], [(TrackBarCodeRes.Position + 1) / 10]);
  S := StringReplace(S, ',', '.', [rfReplaceAll]);
  TimerNormalDelay.Enabled := False;
  TimerNormalDelay.Enabled := True;
  LblDelay.Caption := S;
  OptionsChange;
end;

procedure TFrmEditorOptions.TimerNormalDelayTimer(Sender: TObject);
begin
  LblDelay.Caption := STR_FRM_EDITOR_OPT[123];
  TimerNormalDelay.Enabled := False;
end;

procedure TFrmEditorOptions.BtnChooseCodeTemplateClick(Sender: TObject);
begin
  if OpenDialog.Execute(Handle) then
  begin
    EditCodeTemplate.Text := OpenDialog.FileName;
  end;
end;

procedure TFrmEditorOptions.BtnEditCodeTemplateClick(Sender: TObject);
begin
  if not Assigned(FrmCodeTemplates) then
    FrmCodeTemplates := TFrmCodeTemplates.CreateParented(Handle);
  FrmCodeTemplates.CodeTemplateFileName := EditCodeTemplate.Text;
  FrmCodeTemplates.ShowModal;
end;

procedure TFrmEditorOptions.GroupEnableBoxDisableControls(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to TWinControl(Sender).Parent.ControlCount - 1 do
  begin
    if TWinControl(Sender).Parent.Controls[I] <> Sender then
      TWinControl(Sender).Parent.Controls[I].Enabled := TCheckBox(Sender).Checked;
  end;
  OptionsChange;
end;

procedure TFrmEditorOptions.EditCodeTemplateChange(Sender: TObject);
begin
  BtnEditCodeTemplate.Enabled := FileExists(EditCodeTemplate.Text);
  OptionsChange;
end;

procedure TFrmEditorOptions.Button1Click(Sender: TObject);
begin
  CboEditFont.ItemIndex := CboEditFont.Items.IndexOf('Courier New');
  CboEditFontSelect(Sender);
  CboSize.Text := '10';
  CboSizeChange(Sender);
  ChbShowRMrgn.Checked := True;
  ChbShowgtt.Checked := True;
  ChbShowLnNumb.Checked := True;
  CboRMrg.ItemIndex := 0;
end;

procedure TFrmEditorOptions.BtnRestDefClick(Sender: TObject);
begin
//
  ChbAutoIndt.Checked := True;
  ChbInsMode.Checked := True;
  ChbGrpUnd.Checked := True;
  //-------------------------
  ChbTabUnOrIndt.Checked := True;
  ChbSmartTabs.Checked := True;
  ChbUseTabChar.Checked := True;
  ChbEnhHomeKey.Checked := False;
  ChbShowSpaceChars.Checked := False;
  ChbAutoCloseBrackets.Checked := True;
  CboTabWdt.ItemIndex := 1;
  CboDefEnc.ItemIndex := 0;
  CboDefEncSelect(CboDefEnc);
  ChbWithBOM.Checked := False;
  CboDefLineEnd.ItemIndex := 0;
  OptionsChange;
end;

procedure TFrmEditorOptions.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmEditorOptions.BtnPrevStyleClick(Sender: TObject);
const
  IndexToBracketStyle: array[0..13] of TBracketStyle = (
    stALLMAN, //ANSI
    stKR, //K && R
    stLINUX, //Linux
    stGNU, //GNU
    stJAVA, //Java
    stSTROUSTRUP, //Stroustrup
    stWHITESMITH, //Whitesmith
    stBANNER, //Banner
    stHORSTMANN, //Horstmann
    st1TBS, //1TBS
    stGOOGLE, //Google
    stPICO, //Pico
    stLISP, //Lisp
    stNONE //Custom
  );

  IndexToAlignPointer: array[0..3] of TAlignPointer = (
    apNone,
    apType,
    apMiddle,
    apName
  );

var
  formatter: TAStyle;
  caret: TBufferCoord;
  topLine, I: Integer;
begin
  formatter := TAStyle.Create;
  formatter.MaxInstatementIndent := StrToIntDef(CboRMrg.Text, 80);
  BtnPrevStyle.Visible := RadioGroupFormatterStyles.ItemIndex = RadioGroupFormatterStyles.Items.Count - 1;
  for I := 0 to TSFormatterIndentation.ControlCount - 1 do
  begin
    TSFormatterIndentation.Controls[I].Enabled := BtnPrevStyle.Visible;
  end;
  for I := 0 to TSFormatterPadding.ControlCount - 1 do
  begin
    TSFormatterPadding.Controls[I].Enabled := BtnPrevStyle.Visible;
  end;
  for I := 0 to TSFormatterFormatting.ControlCount - 1 do
  begin
    TSFormatterFormatting.Controls[I].Enabled := BtnPrevStyle.Visible;
  end;
  formatter.BracketStyle := IndexToBracketStyle[RadioGroupFormatterStyles.ItemIndex];
  case IndexToBracketStyle[RadioGroupFormatterStyles.ItemIndex] of
    stALLMAN: // ansi
      begin
        formatter.Properties[aspIndentNamespaces] := True;
        formatter.Properties[aspKeepOneLineStatements] := True;
        formatter.Properties[aspKeepOneLineBlocks] := False;
      end;
    stKR: // K&R
      begin
        formatter.Properties[aspIndentNamespaces] := True;
        formatter.Properties[aspKeepOneLineStatements] := True;
        formatter.Properties[aspKeepOneLineBlocks] := False;
      end;
    stLINUX: //Linux
      begin
        formatter.TabWidth := 8;
        formatter.Properties[aspIndentNamespaces] := True;
        formatter.Properties[aspKeepOneLineStatements] := True;
        formatter.Properties[aspKeepOneLineBlocks] := False;
      end;
    stGNU: //GNU
      begin
        formatter.TabWidth := 2;
        formatter.Properties[aspIndentNamespaces] := True;
        formatter.Properties[aspKeepOneLineStatements] := True;
        formatter.Properties[aspKeepOneLineBlocks] := False;
      end;
    stJAVA: //java
      begin
        formatter.Properties[aspKeepOneLineStatements] := True;
        formatter.Properties[aspKeepOneLineBlocks] := False;
      end;
    stNONE: //custom
      begin
        formatter.TabWidth := StrToIntDef(CboTabWdt.Text, 4);

      //Indentation
        if CheckBoxForceUsingTabs.Checked then
          formatter.TabOptions := toForceTab
        else if ChbUseTabChar.Checked then
          formatter.TabOptions := toTab
        else
          formatter.TabOptions := toSpaces;
        formatter.Properties[aspIndentClasses] := CheckBoxIndentClasses.Checked;
        formatter.Properties[aspIndentSwitches] := CheckBoxIndentSwitches.Checked;
        formatter.Properties[aspIndentCases] := CheckBoxIndentCase.Checked;
        formatter.Properties[aspIndentNamespaces] := CheckBoxIndentNamespaces.Checked;
        formatter.Properties[aspIndentLabels] := CheckBoxIndentLabels.Checked;
        formatter.Properties[aspIndentPreprocDefine] := CheckBoxIndentMultLinePreprocessor.Checked;
        formatter.Properties[aspIndentCol1Comments] := CheckBoxIndentSingleLineComments.Checked;

      //Padding
        formatter.Properties[aspBreakBlocks] := CheckBoxPadEmptyLines.Checked;
        formatter.Properties[aspBreakClosingBrackets] := CheckBoxBreakClosingHeaderBlocks.Checked;
        formatter.Properties[aspPaddingOperator] := CheckBoxInsertSpacePaddingOperators.Checked;
        formatter.Properties[aspPaddingParensOutside] := CheckBoxInsertSpacePaddingParenthesisOutside.Checked;
        formatter.Properties[aspPaddingParensInside] := CheckBoxInsertSpacePaddingParenthesisInside.Checked;
        formatter.Properties[aspPaddingParens] := CheckBoxParenthesisHeaderPadding.Checked;
        formatter.Properties[aspUnpaddingParens] := CheckBoxRemoveExtraSpace.Checked;
        formatter.Properties[aspDeleteEmptyLines] := CheckBoxDeleteEmptyLines.Checked;
        formatter.Properties[aspFillEmptyLines] := CheckBoxFillEmptyLines.Checked;

      //Formatting
        formatter.Properties[aspBreakElseIfs] := CheckBoxBreakElseIf.Checked;
        formatter.Properties[aspAddBrackets] := CheckBoxAddBrackets.Checked;
        formatter.Properties[aspAddOneLineBrackets] := CheckBoxAddOneLineBrackets.Checked;
        formatter.Properties[aspKeepOneLineBlocks] := CheckBoxDontBreakOneLineBlocks.Checked;
        formatter.Properties[aspKeepOneLineStatements] := CheckBoxDontBreakComplex.Checked;
        formatter.Properties[aspConvertTabs] := CheckBoxConvToSpaces.Checked;
        formatter.AlignPointer := IndexToAlignPointer[ComboBoxPointerAlign.ItemIndex];
      end;
  end;
  caret := EditFormatter.CaretXY;
  topLine := EditFormatter.TopLine;
  EditFormatter.SendEditor(SCI_SETTEXT, 0, Integer(formatter.Format(PUTF8String(EditFormatter.GetCharacterPointer))));
  EditFormatter.CaretXY := caret;
  EditFormatter.TopLine := topLine;
  formatter.Free;
end;

procedure TFrmEditorOptions.RadioGroupFormatterStylesClick(Sender: TObject);
begin
  OptionsChange;
  BtnPrevStyleClick(Sender);
end;

procedure TFrmEditorOptions.ComboBoxPointerAlignChange(Sender: TObject);
begin
  OptionsChange;
end;

procedure TFrmEditorOptions.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close
  else if (Key = VK_RETURN) and (Shift = [ssCtrl]) then
    BtnOk.Click;
end;

end.
