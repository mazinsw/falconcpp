unit UFrmFind;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons, UFrmMain, DScintillaTypes;

type
  TFrmFind = class(TForm)
    TabCtrl: TTabControl;
    RGrpSearchMode: TRadioGroup;
    LblRep: TLabel;
    LblFind: TLabel;
    LblSrchOpt: TLabel;
    GBoxTransp: TGroupBox;
    LblOpcty: TLabel;
    ChbTransp: TCheckBox;
    TrkBar: TTrackBar;
    ChbFullWord: TCheckBox;
    ChbDiffCase: TCheckBox;
    ChbCircSearch: TCheckBox;
    CboReplace: TComboBox;
    CboFind: TComboBox;
    BtnReplace: TButton;
    BtnMore: TBitBtn;
    BtnFind: TButton;
    BtnCancel: TButton;
    BvSrchOpt: TBevel;
    GBoxRplcAll: TGroupBox;
    ChbReplSel: TCheckBox;
    BtnReplAll: TButton;
    GBoxDirection: TGroupBox;
    RdbtUp: TRadioButton;
    RdbtDown: TRadioButton;
    ProgressBarFindFiles: TProgressBar;
    procedure FormDeactivate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnMoreClick(Sender: TObject);
    procedure TabCtrlChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure CboFindKeyPress(Sender: TObject; var Key: Char);
    procedure CboFindChange(Sender: TObject);
    procedure CboReplaceKeyPress(Sender: TObject; var Key: Char);
    procedure BtnFindClick(Sender: TObject);
    procedure BtnReplaceClick(Sender: TObject);
    procedure BtnReplAllClick(Sender: TObject);
    procedure CboReplaceEnter(Sender: TObject);
    procedure CboReplaceExit(Sender: TObject);
    procedure CboFindEnter(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure TrkBarChange(Sender: TObject);
    procedure ChbTranspClick(Sender: TObject);
    procedure FindInFiles;
  private
    { Private declarations }
    Frm: TFrmFalconMain;
    FindFilesRunning, FindFilesCanceled: Boolean;
    FindFilesMoreTag: Integer;
    LastFindFilesDescription: string;
    procedure UpdateReplaceHistoryList(Replace: string);
    procedure UpdateSearchHistoryList(Search: string);
  public
    { Public declarations }
    procedure ProgressFindFile(const FileName, Msg: string;
      Line, Column, EndColumn: Integer);
    procedure FinishFindAll(const aSearch: string; Results: Integer;
      Canceled: Boolean);
    function StartFindAll(const OriFindText, aText: string;
      RegExp, Sensitive, WholeWord: Boolean): Boolean;
  end;

var
  FrmFind: TFrmFind = nil;

procedure StartFindText(Frm: TFrmFalconMain);
procedure StartFindNextText(Frm: TFrmFalconMain; LastSearch: TSearchItem);
procedure StartFindPrevText(Frm: TFrmFalconMain; LastSearch: TSearchItem);
procedure StartReplaceText(Frm: TFrmFalconMain);
procedure StartFindFilesText(Frm: TFrmFalconMain);

function ResolveStr(const S: string): string;
function EncodeStr(const S: string): string;

implementation

uses USourceFile, ULanguages, UUtils, UParseMsgs, UEditor;

{$R *.dfm}

procedure StartFindPrevText(Frm: TFrmFalconMain; LastSearch: TSearchItem);
var
  prop: TSourceFile;
  SourceSheet: TSourceFileSheet;
  Editor: TEditor;
  SearchFlags: Integer;
  SearchResultStart, SearchResultEnd, SearchResultCount,
    CurrentPosition: Integer;
  UsingResearch: Boolean;
begin
  if not Frm.GetActiveFile1(prop) then
    Exit;
  if not prop.GetSheet(SourceSheet) then
    Exit;
  Editor := SourceSheet.Editor;
  SearchFlags := 0;
  if LastSearch.DiffCase then
    SearchFlags := SearchFlags or SCFIND_MATCHCASE;
  if LastSearch.FullWord then
    SearchFlags := SearchFlags or SCFIND_WHOLEWORD;
  if LastSearch.SearchMode = 2 then
    SearchFlags := SearchFlags or SCFIND_REGEXP;
  if Length(LastSearch.Search) = 0 then
  begin
    if not Editor.SelAvail then
      Exit;
    LastSearch.Search := Editor.SelText;
    CurrentPosition := Editor.GetSelectionStart;
  end
  else if Editor.SelAvail then
  begin
    CurrentPosition := Editor.GetSelectionStart;
    if (LastSearch.SearchMode <> 2) or
      (Editor.SearchTextEx(LastSearch.Search, SearchFlags, 0,
      Editor.GetSelectionStart, False, sdDown, SearchResultStart,
      SearchResultEnd, UsingResearch, Editor.GetSelectionStart,
      Editor.GetSelectionEnd) = 0) then
    begin
      LastSearch.Search := Editor.SelText;
      if LastSearch.SearchMode = 2 then
        SearchFlags := SearchFlags and not SCFIND_REGEXP;
    end;
  end
  else
    CurrentPosition := Editor.GetCurrentPos;
  SearchResultCount := Editor.SearchTextEx(LastSearch.Search, SearchFlags,
    CurrentPosition, 0, True, sdUp, SearchResultStart, SearchResultEnd,
    UsingResearch);
  if SearchResultCount = 0 then
  begin
    Beep;
    Exit;
  end;
  if UsingResearch then
    MessageBeep(64);
  Frm.SelectFromPosition(SearchResultStart, SearchResultEnd, Editor);
end;

procedure StartFindNextText(Frm: TFrmFalconMain; LastSearch: TSearchItem);
var
  prop: TSourceFile;
  SourceSheet: TSourceFileSheet;
  Editor: TEditor;
  SearchFlags: Integer;
  SearchResultStart, SearchResultEnd, SearchResultCount,
    CurrentPosition: Integer;
  UsingResearch: Boolean;
begin
  if not Frm.GetActiveFile1(prop) then
    Exit;
  if not prop.GetSheet(SourceSheet) then
    Exit;
  Editor := SourceSheet.Editor;
  SearchFlags := 0;
  if LastSearch.DiffCase then
    SearchFlags := SearchFlags or SCFIND_MATCHCASE;
  if LastSearch.FullWord then
    SearchFlags := SearchFlags or SCFIND_WHOLEWORD;
  if LastSearch.SearchMode = 2 then
    SearchFlags := SearchFlags or SCFIND_REGEXP;
  if Length(LastSearch.Search) = 0 then
  begin
    if not Editor.SelAvail then
      Exit;
    LastSearch.Search := Editor.SelText;
    CurrentPosition := Editor.GetSelectionEnd;
  end
  else if Editor.SelAvail then
  begin
    if (LastSearch.SearchMode <> 2) or
      (Editor.SearchTextEx(LastSearch.Search, SearchFlags, 0,
      Editor.GetSelectionStart, False, sdDown, SearchResultStart,
      SearchResultEnd, UsingResearch, Editor.GetSelectionStart,
      Editor.GetSelectionEnd) = 0) then
    begin
      LastSearch.Search := Editor.SelText;
      if LastSearch.SearchMode = 2 then
        SearchFlags := SearchFlags and not SCFIND_REGEXP;
    end;
    CurrentPosition := Editor.GetSelectionEnd;
  end
  else
    CurrentPosition := Editor.GetCurrentPos;
  SearchResultCount := Editor.SearchTextEx(LastSearch.Search, SearchFlags, 0,
    CurrentPosition, True, sdDown, SearchResultStart, SearchResultEnd,
    UsingResearch);
  if SearchResultCount = 0 then
  begin
    Beep;
    Exit;
  end;
  if UsingResearch then
    MessageBeep(64);
  Frm.SelectFromPosition(SearchResultStart, SearchResultEnd, Editor);
end;

procedure StartFindText(Frm: TFrmFalconMain);
var
  prop: TSourceFile;
  SourceSheet: TSourceFileSheet;
  Editor: TEditor;
  SelText: string;
begin
  if not Frm.GetActiveFile1(prop) then
    Exit;
  if not prop.GetSheet(SourceSheet) then
    Exit;
  Editor := SourceSheet.Editor;
  SelText := Editor.SelText;
  if not Editor.SelAvail then
    SelText := Editor.GetWordAtRowCol(Editor.PrevWordPos);

  if FrmFind = nil then
    FrmFind := TFrmFind.Create(Frm);
  FrmFind.Frm := Frm;
  FrmFind.TabCtrl.TabIndex := 0;
  FrmFind.TabCtrlChange(FrmFind.TabCtrl);
  FrmFind.CboFind.Text := SelText;
  FrmFind.CboFindChange(FrmFind.CboFind);
  FrmFind.Show;
end;

procedure StartFindFilesText(Frm: TFrmFalconMain);
var
  prop: TSourceFile;
  SourceSheet: TSourceFileSheet;
  Editor: TEditor;
  SelText: string;
begin
  SelText := '';
  if Frm.GetActiveFile1(prop) then
  begin
    if prop.GetSheet(SourceSheet) then
    begin
      Editor := SourceSheet.Editor;
      SelText := Editor.SelText;
      if not Editor.SelAvail then
        SelText := Editor.GetWordAtRowCol(Editor.PrevWordPos);
    end;
  end;
  if FrmFind = nil then
    FrmFind := TFrmFind.Create(Frm);
  FrmFind.Frm := Frm;
  FrmFind.TabCtrl.TabIndex := 2;
  FrmFind.TabCtrlChange(FrmFind.TabCtrl);
  FrmFind.CboFind.Text := SelText;
  FrmFind.CboFindChange(FrmFind.CboFind);
  FrmFind.Show;
end;

procedure StartReplaceText(Frm: TFrmFalconMain);
var
  prop: TSourceFile;
  SourceSheet: TSourceFileSheet;
  Editor: TEditor;
  SelText: string;
begin
  if not Frm.GetActiveFile1(prop) then
    Exit;
  if not prop.GetSheet(SourceSheet) then
    Exit;
  Editor := SourceSheet.Editor;
  SelText := Editor.SelText;
  if not Editor.SelAvail then
    SelText := Editor.GetWordAtRowCol(Editor.PrevWordPos);
  if FrmFind = nil then
    FrmFind := TFrmFind.Create(Frm);
  FrmFind.Frm := Frm;
  FrmFind.TabCtrl.TabIndex := 1;
  FrmFind.TabCtrlChange(FrmFind.TabCtrl);
  FrmFind.CboFind.Text := SelText;
  FrmFind.CboFindChange(FrmFind.CboFind);
  FrmFind.Show;
end;

function ResolveStr(const S: string): string;
begin
  Result := StringReplace(S, '\n', #10, [rfReplaceAll]);
  Result := StringReplace(Result, '\r', #13, [rfReplaceAll]);
  Result := StringReplace(Result, '\t', #09, [rfReplaceAll]);
end;

function EncodeStr(const S: string): string;
begin
  Result := StringReplace(S, #10, '\n', [rfReplaceAll]);
  Result := StringReplace(Result, #13, '\r', [rfReplaceAll]);
  Result := StringReplace(Result, #09, '\t', [rfReplaceAll]);
end;

procedure TFrmFind.FormDeactivate(Sender: TObject);
begin
  Frm.MenuBar.ProcessShortCuts := True;
  if ChbTransp.Checked then
  begin
    AlphaBlendValue := 55 + TrkBar.Position;
    AlphaBlend := True;
  end
  else
  begin
    AlphaBlend := False;
    AlphaBlendValue := 255;
  end;
end;

procedure TFrmFind.FormActivate(Sender: TObject);
begin
  AlphaBlend := False;
  AlphaBlendValue := 255;
  CboFind.SetFocus;
  Frm.MenuBar.ProcessShortCuts := False;
end;

procedure TFrmFind.FormCreate(Sender: TObject);
var
  bmp: TBitmap;
begin
  ClientHeight := LblSrchOpt.Top + LblSrchOpt.Left + TabCtrl.Top;
  DoubleBuffered := True;
  TabCtrl.DoubleBuffered := True;
  bmp := TBitmap.Create;
  bmp.LoadFromResourceName(HInstance, 'moredown');
  BtnMore.Glyph.Assign(bmp);
  bmp.free;
  ChbDiffCase.Checked := FrmFalconMain.LastSearch.DiffCase;
  ChbFullWord.Checked := FrmFalconMain.LastSearch.FullWord;
  ChbCircSearch.Checked := FrmFalconMain.LastSearch.CircSearch;
  RGrpSearchMode.ItemIndex := FrmFalconMain.LastSearch.SearchMode;
  RdbtUp.Checked := not FrmFalconMain.LastSearch.Direction;
  RdbtDown.Checked := FrmFalconMain.LastSearch.Direction;
  ChbTransp.Checked := FrmFalconMain.LastSearch.Transparence;
  TrkBar.Position := FrmFalconMain.LastSearch.Opacite;
  // Search history
  CboFind.Items.Assign(FrmFalconMain.SearchList);
  CboReplace.Items.Assign(FrmFalconMain.ReplaceList);
  // ****************** translate ************************//
  Caption := STR_FRM_FIND[1];
  TabCtrl.Tabs.Strings[0] := STR_FRM_FIND[2];
  TabCtrl.Tabs.Strings[1] := STR_FRM_FIND[3];
  TabCtrl.Tabs.Strings[2] := STR_FRM_FIND[4];
  LblFind.Caption := STR_FRM_FIND[5];
  LblRep.Caption := STR_FRM_FIND[6];
  BtnReplace.Caption := STR_FRM_FIND[7];
  ChbReplSel.Caption := STR_FRM_FIND[8];
  BtnReplAll.Caption := STR_FRM_FIND[9];
  BtnMore.Caption := STR_FRM_FIND[10];
  BtnFind.Caption := STR_FRM_FIND[12];
  BtnCancel.Caption := STR_FRM_FIND[13];
  LblSrchOpt.Caption := STR_FRM_FIND[14];
  BvSrchOpt.Left := 2 * LblSrchOpt.Left + LblSrchOpt.Width;
  BvSrchOpt.Width := TabCtrl.Width - BvSrchOpt.Left - LblSrchOpt.Left;
  ChbDiffCase.Caption := STR_FRM_FIND[15];
  ChbFullWord.Caption := STR_FRM_FIND[16];
  ChbCircSearch.Caption := STR_FRM_FIND[17];
  RGrpSearchMode.Caption := STR_FRM_FIND[18];
  RGrpSearchMode.Items.Strings[0] := STR_FRM_FIND[19];
  RGrpSearchMode.Items.Strings[1] := STR_FRM_FIND[20];
  RGrpSearchMode.Items.Strings[2] := STR_FRM_FIND[21];
  GBoxDirection.Caption := STR_FRM_FIND[22];
  RdbtUp.Caption := STR_FRM_FIND[23];
  RdbtDown.Caption := STR_FRM_FIND[24];
  GBoxTransp.Caption := '      ' + STR_FRM_FIND[25];
  LblOpcty.Caption := STR_FRM_FIND[26];
end;

procedure TFrmFind.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TFrmFind.BtnMoreClick(Sender: TObject);
var
  bmp: TBitmap;
begin
  bmp := TBitmap.Create;
  if BtnMore.Tag = 1 then
  begin
    ClientHeight := LblSrchOpt.Top + LblSrchOpt.Left + TabCtrl.Top;
    BtnMore.Tag := 0;
    bmp.LoadFromResourceName(HInstance, 'moredown');
    BtnMore.Glyph.Assign(bmp);
    BtnMore.Caption := STR_FRM_FIND[10];
    ChbDiffCase.Visible := False;
    ChbFullWord.Visible := False;
    ChbCircSearch.Visible := False;
    RGrpSearchMode.Visible := False;
    GBoxDirection.Visible := False;
    GBoxTransp.Visible := False;
  end
  else
  begin
    ChbDiffCase.Visible := True;
    ChbFullWord.Visible := True;
    ChbCircSearch.Visible := TabCtrl.TabIndex <> 2;
    RGrpSearchMode.Visible := True;
    GBoxDirection.Visible := TabCtrl.TabIndex <> 2;
    RdbtUp.Enabled := TabCtrl.TabIndex < 1;
    GBoxTransp.Visible := True;
    ClientHeight := RGrpSearchMode.Top + RGrpSearchMode.Height + TabCtrl.Top + 2
      * TabCtrl.Left;
    BtnMore.Tag := 1;
    bmp.LoadFromResourceName(HInstance, 'moreup');
    BtnMore.Glyph.Assign(bmp);
    BtnMore.Caption := STR_FRM_FIND[11];
  end;
  bmp.free;
end;

procedure TFrmFind.TabCtrlChange(Sender: TObject);
begin
  case TabCtrl.TabIndex of
    0:
      begin
        ProgressBarFindFiles.Visible := False;
        LblRep.Caption := STR_FRM_FIND[6];
        BtnFind.Caption := STR_FRM_FIND[12];
        LblRep.Visible := False;
        CboReplace.Visible := False;
        BtnReplace.Visible := False;
        GBoxRplcAll.Visible := False;
        ChbCircSearch.Visible := BtnMore.Tag = 1;
        GBoxDirection.Visible := BtnMore.Tag = 1;
        RdbtUp.Enabled := True;
        BtnMore.Left := BtnFind.Left - BtnMore.Width -
          (BtnCancel.Left - BtnFind.Left - BtnFind.Width);
        BtnMore.Visible := True;
        if Visible then
          CboFind.SetFocus;
      end;
    1:
      begin
        ProgressBarFindFiles.Visible := False;
        LblRep.Caption := STR_FRM_FIND[6];
        BtnFind.Caption := STR_FRM_FIND[12];
        BtnMore.Left := ChbDiffCase.Left;
        BtnReplace.Left := BtnMore.Left + BtnMore.Width +
          (BtnCancel.Left - BtnFind.Left - BtnFind.Width);
        GBoxRplcAll.Left := BtnReplace.Left + BtnReplace.Width +
          (BtnFind.Left - BtnReplace.Left - BtnReplace.Width -
          GBoxRplcAll.Width) div 2;
        LblRep.Visible := True;
        CboReplace.Visible := True;
        BtnReplace.Visible := True;
        GBoxRplcAll.Visible := True;
        ChbCircSearch.Visible := BtnMore.Tag = 1;
        GBoxDirection.Visible := BtnMore.Tag = 1;
        RdbtDown.Checked := True;
        RdbtUp.Enabled := False;
        BtnMore.Visible := True;
        if Visible then
          CboFind.SetFocus;
      end;
    2:
      begin
        ProgressBarFindFiles.Visible := FindFilesRunning;
        LblRep.Visible := FindFilesRunning;
        if not FindFilesRunning then
        begin
          LblRep.Caption := STR_FRM_FIND[6];
          BtnFind.Caption := STR_FRM_FIND[2];
        end
        else
        begin
          LblRep.Caption := LastFindFilesDescription;
          BtnFind.Caption := STR_FRM_FIND[32];
          BtnMore.Tag := 1;
          BtnMoreClick(BtnMore);
        end;
        CboReplace.Visible := False;
        BtnReplace.Visible := False;
        GBoxRplcAll.Visible := False;
        ChbCircSearch.Visible := False;
        GBoxDirection.Visible := False;
        BtnMore.Visible := not FindFilesRunning;
        BtnMore.Left := BtnFind.Left - BtnMore.Width -
          (BtnCancel.Left - BtnFind.Left - BtnFind.Width);
        if Visible then
          CboFind.SetFocus;
      end;
  end;
end;

procedure TFrmFind.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FrmFalconMain.LastSearch.DiffCase := ChbDiffCase.Checked;
  FrmFalconMain.LastSearch.FullWord := ChbFullWord.Checked;
  FrmFalconMain.LastSearch.CircSearch := ChbCircSearch.Checked;
  FrmFalconMain.LastSearch.SearchMode := RGrpSearchMode.ItemIndex;
  FrmFalconMain.LastSearch.Direction := RdbtDown.Checked;
  FrmFalconMain.LastSearch.Transparence := ChbTransp.Checked;
  FrmFalconMain.LastSearch.Opacite := TrkBar.Position;
  Action := caFree;
end;

procedure TFrmFind.FormDestroy(Sender: TObject);
begin
  FrmFind := nil;
end;

procedure TFrmFind.CboFindKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    if not BtnFind.Enabled then
      Beep;
    Key := #0;
  end;
  if Key = #27 then
    Key := #0;
end;

procedure TFrmFind.CboFindChange(Sender: TObject);
begin
  BtnReplace.Enabled := Length(CboFind.Text) > 0;
  BtnReplAll.Enabled := BtnReplace.Enabled;
  BtnFind.Enabled := BtnReplace.Enabled;
end;

procedure TFrmFind.CboReplaceKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    if not BtnReplace.Enabled then
      Beep;
    Key := #0;
  end;
  if Key = #27 then
    Key := #0;
end;

procedure TFrmFind.ProgressFindFile(const FileName, Msg: string;
  Line, Column, EndColumn: Integer);
begin
  FrmFalconMain.AddMessage(FileName, ExtractFileName(FileName), Msg, Line,
    Column, EndColumn, mitFound, False);
end;

procedure TFrmFind.FinishFindAll(const aSearch: string; Results: Integer;
  Canceled: Boolean);
begin
  TabCtrl.TabIndex := 2;
  FindFilesRunning := False;
  FindFilesCanceled := False;
  LblRep.Caption := STR_FRM_FIND[6];
  LblRep.Visible := False;
  BtnFind.Caption := STR_FRM_FIND[2];
  ProgressBarFindFiles.Visible := False;
  BtnMore.Visible := True;
  BtnMore.Tag := FindFilesMoreTag;
  BtnMoreClick(BtnMore);
  LastFindFilesDescription := '';
  if Canceled then
    Exit;
  if Results = 0 then
  begin
    AlphaBlend := False;
    AlphaBlendValue := 255;
    MessageBox(Handle, PChar(Format(STR_FRM_FIND[30], [aSearch])),
      PChar(StringReplace(STR_FRM_FIND[2], '&', '', [])), MB_OK);
    Exit;
  end;
  FrmFalconMain.PanelMessages.Show;
  Close;
end;

function TFrmFind.StartFindAll(const OriFindText, aText: string;
  RegExp, Sensitive, WholeWord: Boolean): Boolean;
var
  Files: TStrings;
  FileName: string;
  FileProp: TSourceFile;
  I, Results: Integer;
  // TODO: commented
  // Search: TSynEditSearchCustom;
  SourceSheet: TSourceFileSheet;
  // TODO: commented
  // SearchFlags: TSynSearchOptions;
  Lines: TStrings;

  procedure CheckIfCanceled;
  begin
    if FindFilesCanceled then
    begin
      Files.free;
      // TODO: commented
      // Search.Free;
      FinishFindAll(OriFindText, Results, FindFilesCanceled);
      Exit;
    end;
  end;

begin
  // TODO: commented
  // SearchFlags := [];
  // if Sensitive then
  // SearchFlags := SearchFlags + [ssoMatchCase];
  // if WholeWord then
  // SearchFlags := SearchFlags + [ssoWholeWord];
  Result := False;
  Results := 0;
  Files := TStringList.Create;
  // TODO: commented
  // if RegExp then
  // Search := TSynEditRegexSearch.Create(nil)
  // else
  // Search := TSynEditSearch.Create(nil);
  CheckIfCanceled;
  // TODO: commented
  // Search.Options := SearchFlags;
  // Search.Pattern := aText;
  FrmFalconMain.ListViewMsg.Clear;
  I := FrmFalconMain.GetSourcesFiles(Files, True);
  ProgressBarFindFiles.Max := I;
  Lines := TStringList.Create;
  for I := 0 to Files.Count - 1 do
  begin
    CheckIfCanceled;
    ProgressBarFindFiles.Position := I + 1;
    FileProp := TSourceFile(Files.Objects[I]);
    FileName := FileProp.FileName;
    LastFindFilesDescription := Format(STR_FRM_FIND[33],
      [OriFindText, FileProp.Name]);
    LblRep.Caption := LastFindFilesDescription;

    if FileProp.GetSheet(SourceSheet) then
      Lines.Assign(SourceSheet.Editor.Lines)
    else
      FileProp.LoadFile(Lines);
    // TODO: commented
    // Results := Results + Search.FindAll(Lines.Text);
    CheckIfCanceled;
    // TODO: commented
    // for J := 0 to Search.ResultCount - 1 do
    // begin
    // GetRowColFromCharIndex(Search.Results[J], Lines, Line, Column);
    // if Column > 1 then
    // Dec(Column);
    // EndColumn := Column + Search.Lengths[J];
    // ProgressFindFile(FileName, Format(STR_FRM_FIND[34],
    // [OriFindText, Line, Column]), Line, Column, EndColumn);
    // Application.ProcessMessages;
    // CheckIfCanceled;
    // end;
    Application.ProcessMessages;
  end;
  Lines.free;
  // TODO: commented
  // Search.Free;
  Files.free;
  FinishFindAll(OriFindText, Results, FindFilesCanceled);
end;

procedure TFrmFind.FindInFiles;
var
  Search: string;
begin
  if not FindFilesRunning then
  begin
    FindFilesCanceled := False;
    FindFilesRunning := True;
    LblRep.Visible := True;
    BtnFind.Caption := STR_FRM_FIND[32];
    ProgressBarFindFiles.Visible := True;
    BtnMore.Visible := False;
    if BtnMore.Tag = 1 then
      FindFilesMoreTag := 0
    else
      FindFilesMoreTag := 1;
    BtnMore.Tag := 1;
    BtnMoreClick(BtnMore);
    Search := CboFind.Text;
    if RGrpSearchMode.ItemIndex = 1 then // resolve \n \r \t
      Search := ResolveStr(Search);
    StartFindAll(CboFind.Text, Search, RGrpSearchMode.ItemIndex = 2,
      ChbDiffCase.Checked, ChbFullWord.Checked);
  end
  else
  begin
    if FindFilesRunning then
      FindFilesCanceled := True;
  end;
end;

procedure TFrmFind.UpdateSearchHistoryList(Search: string);
var
  I, ItemIndex: Integer;
begin
  if Search = '' then
    Exit;
  I := FrmFalconMain.SearchList.IndexOf(Search);
  if I > 0 then
  begin
    FrmFalconMain.SearchList.Move(I, 0);
    ItemIndex := CboFind.ItemIndex;
    CboFind.Items.Move(I, 0);
    if ItemIndex = I then
      CboFind.ItemIndex := 0;
  end
  else if I < 0 then
  begin
    FrmFalconMain.SearchList.Insert(0, Search);
    CboFind.Items.Insert(0, Search);
    if FrmFalconMain.SearchList.Count > 10 then
    begin
      FrmFalconMain.SearchList.Delete(10);
      CboFind.Items.Delete(10);
    end;
  end;
end;

procedure TFrmFind.UpdateReplaceHistoryList(Replace: string);
var
  I, ItemIndex: Integer;
begin
  if Replace = '' then
    Exit;
  I := FrmFalconMain.ReplaceList.IndexOf(Replace);
  if I > 0 then
  begin
    FrmFalconMain.ReplaceList.Move(I, 0);
    ItemIndex := CboReplace.ItemIndex;
    CboReplace.Items.Move(I, 0);
    if ItemIndex = I then
      CboReplace.ItemIndex := 0;
  end
  else if I < 0 then
  begin
    FrmFalconMain.ReplaceList.Insert(0, Replace);
    CboReplace.Items.Insert(0, Replace);
    if FrmFalconMain.ReplaceList.Count > 10 then
    begin
      FrmFalconMain.ReplaceList.Delete(10);
      CboReplace.Items.Delete(10);
    end;
  end;
end;

procedure TFrmFind.BtnFindClick(Sender: TObject);
var
  SourceSheet: TSourceFileSheet;
  Editor: TEditor;
  Search: string;
  SearchResultCount, SearchResultStart, SearchResultEnd: Integer;
  rect, selRect: TRect;
  StartPosition, EndPosition: Integer;
  isAbove, UsingResearch: Boolean;
  SearchFlags: Integer;
  Direction: TSearchDirection;
begin
  UpdateSearchHistoryList(CboFind.Text);
  if TabCtrl.TabIndex = 2 then
  begin
    FindInFiles;
    Exit;
  end;
  if not Frm.GetActiveSheet(SourceSheet) then
    Exit;
  Editor := SourceSheet.Editor;
  if Editor.SelAvail then
  begin
    StartPosition := Editor.GetSelectionStart;
    EndPosition := Editor.GetSelectionEnd;
  end
  else
  begin
    StartPosition := Editor.GetCurrentPos;
    EndPosition := StartPosition;
  end;
  Search := CboFind.Text;
  if RGrpSearchMode.ItemIndex = 1 then // resolve \n \r \t
    Search := ResolveStr(Search);
  SearchFlags := 0;
  if ChbDiffCase.Checked then
    SearchFlags := SearchFlags or SCFIND_MATCHCASE;
  if ChbFullWord.Checked then
    SearchFlags := SearchFlags or SCFIND_WHOLEWORD;
  if RGrpSearchMode.ItemIndex = 2 then
    SearchFlags := SearchFlags or SCFIND_REGEXP;
  if RdbtUp.Checked then
    Direction := sdUp
  else
    Direction := sdDown;
  SearchResultCount := Editor.SearchTextEx(Search, SearchFlags, StartPosition,
    EndPosition, ChbCircSearch.Checked, Direction, SearchResultStart,
    SearchResultEnd, UsingResearch);
  if SearchResultCount = 0 then
  begin
    AlphaBlend := False;
    AlphaBlendValue := 255;
    MessageBox(Handle, PChar(Format(STR_FRM_FIND[30], [Search])),
      PChar(StringReplace(STR_FRM_FIND[2], '&', '', [])), MB_OK);
    Exit;
  end;
  FrmFalconMain.SelectFromPosition(SearchResultStart, SearchResultEnd, Editor);
  Frm.LastSearch.Search := Search;
  Frm.LastSearch.SearchMode := RGrpSearchMode.ItemIndex;
  Frm.LastSearch.DiffCase := ChbDiffCase.Checked;
  Frm.LastSearch.FullWord := ChbFullWord.Checked;
  if ChbTransp.Checked then
  begin
    selRect.TopLeft := Editor.RowColumnToPixels
      (Editor.BufferToDisplayPos(Editor.BlockBegin));
    selRect.BottomRight := Editor.RowColumnToPixels
      (Editor.BufferToDisplayPos(Editor.BlockEnd));
    Inc(selRect.Bottom, Editor.LineHeight);
    selRect.TopLeft := Editor.ClientToScreen(selRect.TopLeft);
    selRect.BottomRight := Editor.ClientToScreen(selRect.BottomRight);
    GetWindowRect(Handle, rect);
    isAbove := PtInRect(rect, selRect.TopLeft) = True;
    if not isAbove then
      isAbove := PtInRect(rect, selRect.BottomRight) = True;
    if not isAbove then
    begin
      Inc(selRect.Top, Editor.LineHeight);
      Dec(selRect.Bottom, Editor.LineHeight);
      isAbove := PtInRect(rect, selRect.TopLeft) = True;
      if not isAbove then
        isAbove := PtInRect(rect, selRect.BottomRight) = True;
    end;
    if isAbove then
    begin
      AlphaBlendValue := 55 + TrkBar.Position;
      AlphaBlend := True;
    end
    else
    begin
      AlphaBlend := False;
      AlphaBlendValue := 255;
    end;
  end
  else
  begin
    AlphaBlend := False;
    AlphaBlendValue := 255;
  end;
end;

procedure TFrmFind.BtnReplaceClick(Sender: TObject);
var
  SourceSheet: TSourceFileSheet;
  Editor: TEditor;
  Search, Replace: string;
  StartPosition, EndPosition: Integer;
  SearchResultStart, SearchResultEnd, SearchResultCount, ReplaceLength: Integer;
  UsingResearch: Boolean;
  SearchFlags: Integer;
begin
  if not Frm.GetActiveSheet(SourceSheet) then
    Exit;
  UpdateReplaceHistoryList(CboReplace.Text);
  Editor := SourceSheet.Editor;
  if Editor.SelAvail then
  begin
    StartPosition := Editor.GetSelectionStart;
    EndPosition := Editor.GetSelectionEnd;
  end
  else
  begin
    StartPosition := Editor.GetCurrentPos;
    EndPosition := StartPosition;
  end;
  Search := CboFind.Text;
  Replace := CboReplace.Text;
  if RGrpSearchMode.ItemIndex = 1 then // resolve \n \r \t
    Search := ResolveStr(Search);
  if RGrpSearchMode.ItemIndex = 1 then // resolve \n \r \t
    Replace := ResolveStr(Replace);
  SearchFlags := 0;
  if ChbDiffCase.Checked then
    SearchFlags := SearchFlags or SCFIND_MATCHCASE;
  if ChbFullWord.Checked then
    SearchFlags := SearchFlags or SCFIND_WHOLEWORD;
  if RGrpSearchMode.ItemIndex = 2 then
    SearchFlags := SearchFlags or SCFIND_REGEXP;
  // compare and Replace **********
  SearchResultCount := Editor.SearchTextEx(Search, SearchFlags, 0,
    StartPosition, ChbCircSearch.Checked, sdDown, SearchResultStart,
    SearchResultEnd, UsingResearch, StartPosition, EndPosition);
  if SearchResultCount = 1 then
  begin
    Editor.SetTargetStart(SearchResultStart);
    Editor.SetTargetEnd(SearchResultEnd);
    if (SearchFlags and SCFIND_REGEXP) = SCFIND_REGEXP then
      ReplaceLength := Editor.ReplaceTargetRE(Replace)
    else
      ReplaceLength := Editor.ReplaceTarget(Replace);
    Editor.SetCurrentPos(SearchResultStart + ReplaceLength);
  end;
  // ******************************
  BtnFindClick(Sender);
end;

procedure TFrmFind.BtnReplAllClick(Sender: TObject);
var
  SourceSheet: TSourceFileSheet;
  Editor: TEditor;
  Search, Replace: string;
  StartPosition, DocEndPosition: Integer;
  SearchResultStart, SearchResultEnd, SearchResultCount, ReplaceLength: Integer;
  UsingResearch: Boolean;
  SearchFlags: Integer;
  ReplaceCount: Integer;
begin
  if not Frm.GetActiveSheet(SourceSheet) then
    Exit;
  UpdateReplaceHistoryList(CboReplace.Text);
  Editor := SourceSheet.Editor;
  if ChbReplSel.Checked and Editor.SelAvail then
  begin
    StartPosition := Editor.GetSelectionStart;
    DocEndPosition := Editor.GetSelectionEnd;
  end
  else
  begin
    if ChbReplSel.Checked then
    begin
      StartPosition := Editor.GetCurrentPos;
      DocEndPosition := StartPosition;
    end
    else
    begin
      if ChbCircSearch.Checked then
        StartPosition := 0
      else if Editor.SelAvail then
        StartPosition := Editor.GetSelectionStart
      else
        StartPosition := Editor.GetCurrentPos;
      DocEndPosition := Editor.GetLength - 1;
    end;
  end;
  Search := CboFind.Text;
  Replace := CboReplace.Text;
  if RGrpSearchMode.ItemIndex = 1 then // resolve \n \r \t
    Search := ResolveStr(Search);
  if RGrpSearchMode.ItemIndex = 1 then // resolve \n \r \t
    Replace := ResolveStr(Replace);
  SearchFlags := 0;
  if ChbDiffCase.Checked then
    SearchFlags := SearchFlags or SCFIND_MATCHCASE;
  if ChbFullWord.Checked then
    SearchFlags := SearchFlags or SCFIND_WHOLEWORD;
  if RGrpSearchMode.ItemIndex = 2 then
    SearchFlags := SearchFlags or SCFIND_REGEXP;
  ReplaceCount := 0;
  // compare and Replace **********
  Editor.BeginUndoAction;
  repeat
    SearchResultCount := Editor.SearchTextEx(Search, SearchFlags, 0,
      StartPosition, ChbCircSearch.Checked, sdDown, SearchResultStart,
      SearchResultEnd, UsingResearch, StartPosition, DocEndPosition);
    if SearchResultCount <> 1 then
      Break;
    Editor.ClearSelections;
    Editor.SetTargetStart(SearchResultStart);
    Editor.SetTargetEnd(SearchResultEnd);
    if (SearchFlags and SCFIND_REGEXP) = SCFIND_REGEXP then
      ReplaceLength := Editor.ReplaceTargetRE(Replace)
    else
      ReplaceLength := Editor.ReplaceTarget(Replace);
    StartPosition := SearchResultStart + ReplaceLength;
    DocEndPosition := DocEndPosition - (SearchResultEnd - SearchResultStart) + ReplaceLength;
    Editor.SetEmptySelection(StartPosition);
    Inc(ReplaceCount);
  until False;
  Editor.EndUndoAction;
  MessageBox(Handle, PChar(Format(STR_FRM_FIND[31], [ReplaceCount])),
    PChar(STR_FRM_FIND[9]), MB_OK);
end;

procedure TFrmFind.CboReplaceEnter(Sender: TObject);
begin
  BtnFind.Default := False;
  BtnReplace.Default := True;
end;

procedure TFrmFind.CboReplaceExit(Sender: TObject);
begin
  BtnReplace.Default := False;
  BtnFind.Default := True;
end;

procedure TFrmFind.CboFindEnter(Sender: TObject);
begin
  BtnFind.Default := True;
end;

procedure TFrmFind.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmFind.TrkBarChange(Sender: TObject);
begin
  if AlphaBlend then
    AlphaBlendValue := 55 + TrkBar.Position;
end;

procedure TFrmFind.ChbTranspClick(Sender: TObject);
begin
  if AlphaBlend and not ChbTransp.Checked then
    AlphaBlend := False;
end;

end.
