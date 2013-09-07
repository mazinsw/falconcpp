unit UFrmFind;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons, UFrmMain, SynMemo, 
  SynEditTypes, SynEditSearch, SynEditRegexSearch;

const
  reduce_rate_form = 0.494475138121547;
  reduce_rate_tab = 0.4756446991404011;
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
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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
    procedure ProgressFindFile(const FileName, Msg: string; Line,
      Column, EndColumn: Integer);
    procedure FinishFindAll(const aSearch: string; Results: Integer; Canceled: Boolean);
    function StartFindAll(const OriFindText, aText: string; RegExp, Sensitive,
      WholeWord: Boolean): Boolean;
  end;

var
  FrmFind: TFrmFind = nil;

procedure StartFindText(frm: TFrmFalconMain);
procedure StartFindNextText(frm: TFrmFalconMain; LastSearch: TSearchItem);
procedure StartFindPrevText(frm: TFrmFalconMain; LastSearch: TSearchItem);
procedure StartReplaceText(frm: TFrmFalconMain);
procedure StartFindFilesText(frm: TFrmFalconMain);

function ResolveStr(const S: string): string;
function EncodeStr(const S: string): string;

implementation

uses USourceFile, SynEditMiscClasses, ULanguages,
  UUtils, UParseMsgs, SynEdit;

{$R *.dfm}

procedure StartFindText(frm: TFrmFalconMain);
var
  prop: TSourceFile;
  sheet: TSourceFileSheet;
  memo: TSynEdit;
  seltext: string;
begin
  if not frm.GetActiveFile(prop) then
    Exit;
  if not prop.GetSheet(sheet) then
    Exit;
  memo := sheet.Memo;
  seltext := memo.SelText;
  if not memo.SelAvail then
    seltext := memo.GetWordAtRowCol(memo.PrevWordPos);

  if FrmFind = nil then
    FrmFind := TFrmFind.Create(frm);
  FrmFind.Frm := frm;
  FrmFind.TabCtrl.TabIndex := 0;
  FrmFind.TabCtrlChange(FrmFind.TabCtrl);
  FrmFind.CboFind.Text := seltext;
  FrmFind.CboFindChange(FrmFind.CboFind);
  FrmFind.Show;
end;

procedure StartFindNextText(frm: TFrmFalconMain; LastSearch: TSearchItem);
var
  prop: TSourceFile;
  sheet: TSourceFileSheet;
  memo: TSynEdit;
  BE: TBufferCoord;
  sopt: TSynSearchOptions;
  I, Start, Index, Count, SelEnd: Integer;
begin
  if not frm.GetActiveFile(prop) then
    Exit;
  if not prop.GetSheet(sheet) then
    Exit;
  memo := sheet.Memo;
  if Length(LastSearch.Search) = 0 then
  begin
    if not memo.SelAvail then
      Exit;
    LastSearch.Search := memo.SelText;
  end
  else if memo.SelAvail then
    LastSearch.Search := memo.SelText;
  sopt := [];
  if LastSearch.DiffCase then
    sopt := sopt + [ssoMatchCase];
  if LastSearch.FullWord then
    sopt := sopt + [ssoWholeWord];
  if LastSearch.SearchMode = 2 then
    memo.SearchEngine := frm.EditorRegexSearch
  else
    memo.SearchEngine := frm.EditorSearch;
  memo.SearchEngine.Pattern := LastSearch.Search;
  memo.SearchEngine.Options := sopt;
  { TODO -oMazin -c : Change to Lines 04/05/2013 22:14:59 }
  memo.SearchEngine.FindAll(memo.UnCollapsedLines.Text);
  Start := 0;
  Count := 0;
  if memo.SelAvail then
    BE := memo.BlockEnd
  else
    BE := memo.CaretXY;
  BE.Line := memo.GetRealLineNumber(BE.Line);
  SelEnd := memo.RowColToCharIndex(BE);
  for I := 0 to memo.SearchEngine.ResultCount - 1 do
    if memo.SearchEngine.Results[I] > SelEnd then
    begin
      Count := memo.SearchEngine.ResultCount - I;
      Start := I;
      Break;
    end;
  if Count = 0 then
  begin
    MessageBox(frm.Handle, PChar(Format(STR_FRM_FIND[30], [LastSearch.Search])),
      PChar(StringReplace(STR_FRM_FIND[2], '&', '', [])), MB_OK);
    Exit;
  end;
  Index := -1;
  for I := Start to memo.SearchEngine.ResultCount - 1 do
    if memo.SearchEngine.Results[I] > SelEnd then
    begin
      Index := I;
      Break;
    end;
  if Index = -1 then
    Index := Start;
  I := memo.SearchEngine.Results[Index];
  Count := memo.SearchEngine.Lengths[Index];
  frm.SelectFromSelStart(I - 1, Count, memo);
end;

procedure StartFindPrevText(frm: TFrmFalconMain; LastSearch: TSearchItem);
var
  prop: TSourceFile;
  sheet: TSourceFileSheet;
  memo: TSynEdit;
  sopt: TSynSearchOptions;
  BS: TBufferCoord;
  I, Start, Index, Count, SelStart: Integer;
begin
  if not frm.GetActiveFile(prop) then
    Exit;
  if not prop.GetSheet(sheet) then
    Exit;
  memo := sheet.Memo;
  if Length(LastSearch.Search) = 0 then
  begin
    if not memo.SelAvail then
      Exit;
    LastSearch.Search := memo.SelText;
  end
  else if memo.SelAvail then
    LastSearch.Search := memo.SelText;
  sopt := [];
  if LastSearch.DiffCase then
    sopt := sopt + [ssoMatchCase];
  if LastSearch.FullWord then
    sopt := sopt + [ssoWholeWord];
  if LastSearch.SearchMode = 2 then
    memo.SearchEngine := frm.EditorRegexSearch
  else
    memo.SearchEngine := frm.EditorSearch;
  memo.SearchEngine.Pattern := LastSearch.Search;
  memo.SearchEngine.Options := sopt;
  { TODO -oMazin -c : Change to Lines 04/05/2013 22:14:59 }
  memo.SearchEngine.FindAll(memo.UnCollapsedLines.Text);
  Start := 0;
  Count := 0;
  if memo.SelAvail then
    BS := memo.BlockBegin
  else
    BS := memo.CaretXY;
  BS.Line := memo.GetRealLineNumber(BS.Line);
  selstart := memo.RowColToCharIndex(BS);
  for I := 0 to memo.SearchEngine.ResultCount - 1 do
    if memo.SearchEngine.Results[I] > SelStart then
    begin
      Count := I;
      Start := I - 1;
      Break;
    end;
  if (Count = 0) and (Start = 0) then
  begin
    Count := memo.SearchEngine.ResultCount;
    Start := Count - 1;
  end;
  if Count = 0 then
  begin
    MessageBox(frm.Handle, PChar(Format(STR_FRM_FIND[30], [LastSearch.Search])),
      PChar(StringReplace(STR_FRM_FIND[2], '&', '', [])), MB_OK);
    Exit;
  end;
  Index := Start;
  I := memo.SearchEngine.Results[Index];
  Count := memo.SearchEngine.Lengths[Index];
  frm.SelectFromSelStart(I - 1, Count, memo);
end;

procedure StartFindFilesText(frm: TFrmFalconMain);
var
  prop: TSourceFile;
  sheet: TSourceFileSheet;
  memo: TSynEdit;
  seltext: string;
begin
  seltext := '';
  if frm.GetActiveFile(prop) then
  begin
    if prop.GetSheet(sheet) then
    begin
      memo := sheet.Memo;
      seltext := memo.SelText;
      if not memo.SelAvail then
        seltext := memo.GetWordAtRowCol(memo.PrevWordPos);
    end;
  end;
  if FrmFind = nil then
    FrmFind := TFrmFind.Create(frm);
  FrmFind.Frm := frm;
  FrmFind.TabCtrl.TabIndex := 2;
  FrmFind.TabCtrlChange(FrmFind.TabCtrl);
  FrmFind.CboFind.Text := seltext;
  FrmFind.CboFindChange(FrmFind.CboFind);
  FrmFind.Show;
end;

procedure StartReplaceText(frm: TFrmFalconMain);
var
  prop: TSourceFile;
  sheet: TSourceFileSheet;
  memo: TSynEdit;
  seltext: string;
begin
  if not frm.GetActiveFile(prop) then
    Exit;
  if not prop.GetSheet(sheet) then
    Exit;
  memo := sheet.Memo;
  seltext := memo.SelText;
  if not memo.SelAvail then
    seltext := memo.GetWordAtRowCol(memo.PrevWordPos);
  if FrmFind = nil then
    FrmFind := TFrmFind.Create(frm);
  FrmFind.Frm := frm;
  FrmFind.TabCtrl.TabIndex := 1;
  FrmFind.TabCtrlChange(FrmFind.TabCtrl);
  FrmFind.CboFind.Text := seltext;
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
  frm.MenuBar.ProcessShortCuts := True;
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
  frm.MenuBar.ProcessShortCuts := False;
end;

procedure TFrmFind.FormCreate(Sender: TObject);
var
  bmp: TBitmap;
begin
  ClientHeight := Round(ClientHeight * reduce_rate_form);
  TabCtrl.Height := Round(TabCtrl.Height * reduce_rate_tab);
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
  // search history
  CboFind.Items.Assign(FrmFalconMain.SearchList);
  CboReplace.Items.Assign(FrmFalconMain.ReplaceList);
  //****************** translate ************************//
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
  BvSrchOpt.Left := LblSrchOpt.Left + LblSrchOpt.Width + 9;
  BvSrchOpt.Width := TabCtrl.Width - BvSrchOpt.Left - 13;
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
    ClientHeight := Round(ClientHeight * reduce_rate_form);
    TabCtrl.Height := Round(TabCtrl.Height * reduce_rate_tab);
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
    ClientHeight := Round(ClientHeight / reduce_rate_form);
    TabCtrl.Height := Round(TabCtrl.Height / reduce_rate_tab);
    BtnMore.Tag := 1;
    bmp.LoadFromResourceName(HInstance, 'moreup');
    BtnMore.Glyph.Assign(bmp);
    BtnMore.Caption := STR_FRM_FIND[11];
  end;
  bmp.Free;
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
        BtnMore.Left := 231;
        BtnMore.Visible := True;
        if Visible then
          CboFind.SetFocus;
      end;
    1:
      begin
        ProgressBarFindFiles.Visible := False;
        LblRep.Caption := STR_FRM_FIND[6];
        BtnFind.Caption := STR_FRM_FIND[12];
        BtnReplace.Left := 131;
        GBoxRplcAll.Left := 228;
        LblRep.Visible := True;
        CboReplace.Visible := True;
        BtnReplace.Visible := True;
        GBoxRplcAll.Visible := True;
        ChbCircSearch.Visible := BtnMore.Tag = 1;
        GBoxDirection.Visible := BtnMore.Tag = 1;
        RdbtDown.Checked := True;
        RdbtUp.Enabled := False;
        BtnMore.Left := 31;
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
        BtnMore.Left := 231;
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

procedure TFrmFind.FinishFindAll(const aSearch: string; Results: Integer; Canceled: Boolean);
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

function TFrmFind.StartFindAll(const OriFindText, aText: string; RegExp, Sensitive,
  WholeWord: Boolean): Boolean;
var
  Files: TStrings;
  FileName: string;
  FileProp: TSourceFile;
  I, J, Results, Line, Column, EndColumn: Integer;
  Search: TSynEditSearchCustom;
  sheet: TSourceFileSheet;
  sopt: TSynSearchOptions;
  Lines: TStrings;

  procedure CheckIfCanceled;
  begin
    if FindFilesCanceled then
    begin
      Files.Free;
      Search.Free;
      FinishFindAll(OriFindText, Results, FindFilesCanceled);
      Exit;
    end;
  end;

begin
  sopt := [];
  if Sensitive then
    sopt := sopt + [ssoMatchCase];
  if WholeWord then
    sopt := sopt + [ssoWholeWord];
  Result := False;
  Results := 0;
  Files := TStringList.Create;
  if RegExp then
    Search := TSynEditRegexSearch.Create(nil)
  else
    Search := TSynEditSearch.Create(nil);
  CheckIfCanceled;
  Search.Options := sopt;
  Search.Pattern := aText;
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
    LastFindFilesDescription := Format(STR_FRM_FIND[33], [OriFindText, FileProp.Name]);
    LblRep.Caption := LastFindFilesDescription;

    if FileProp.GetSheet(sheet) then
      Lines.Assign(sheet.Memo.UnCollapsedLines)
    else
      FileProp.LoadFile(Lines);
    Results := Results + Search.FindAll(Lines.Text);
    CheckIfCanceled;
    for J := 0 to Search.ResultCount - 1 do
    begin
      GetRowColFromCharIndex(Search.Results[J], Lines, Line, Column);
      if Column > 1 then
        Dec(Column);
      EndColumn := Column + Search.Lengths[J];
      ProgressFindFile(FileName, Format(STR_FRM_FIND[34],
        [OriFindText, Line, Column]), Line, Column, EndColumn);
      Application.ProcessMessages;
      CheckIfCanceled;
    end;
    Application.ProcessMessages;
  end;
  Lines.Free;
  Search.Free;
  Files.Free;
  FinishFindAll(OriFindText, Results, FindFilesCanceled);
end;

procedure TFrmFind.FindInFiles;
var
  search: string;
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
    search := CboFind.Text;
    if RGrpSearchMode.ItemIndex = 1 then //resolve \n \r \t
      search := ResolveStr(search);
    StartFindAll(CboFind.Text, search, RGrpSearchMode.ItemIndex = 2, ChbDiffCase.Checked, ChbFullWord.Checked);
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
  sheet: TSourceFileSheet;
  memo: TSynEdit;
  search: string;
  I, Start, Index, Count, lastlength, selstart, selend: Integer;
  pt: TPoint;
  rect: TRect;
  sopt: TSynSearchOptions;
  BS, BE: TBufferCoord;
begin
  UpdateSearchHistoryList(CboFind.Text);
  if TabCtrl.TabIndex = 2 then
  begin
    FindInFiles;
    Exit;
  end;
  if not frm.GetActiveSheet(sheet) then
    Exit;
  memo := sheet.Memo;
  search := CboFind.Text;
  sopt := [];
  if RGrpSearchMode.ItemIndex = 1 then //resolve \n \r \t
    search := ResolveStr(search);
  if ChbCircSearch.Checked then
    sopt := sopt + [ssoEntireScope];
  if ChbDiffCase.Checked then
    sopt := sopt + [ssoMatchCase];
  if ChbFullWord.Checked then
    sopt := sopt + [ssoWholeWord];
  if RGrpSearchMode.ItemIndex = 2 then
    memo.SearchEngine := FrmFalconMain.EditorRegexSearch
  else
    memo.SearchEngine := FrmFalconMain.EditorSearch;
  memo.SearchEngine.Pattern := search;
  memo.SearchEngine.Options := sopt;
  { TODO -oMazin -c : Change to Lines 04/05/2013 22:14:59 }
  memo.SearchEngine.FindAll(memo.UnCollapsedLines.Text);
  Count := memo.SearchEngine.ResultCount;
  Start := 0;
  if memo.SelAvail then
    BS := memo.BlockBegin
  else
    BS := memo.CaretXY;
  BS.Line := memo.GetRealLineNumber(BS.Line);
  selstart := memo.RowColToCharIndex(BS);
  if memo.SelAvail then
    BE := memo.BlockEnd
  else
    BE := memo.CaretXY;
  BE.Line := memo.GetRealLineNumber(BE.Line);
  selend := memo.RowColToCharIndex(BE);
  if not ChbCircSearch.Checked then
  begin
    Count := 0;
    if RdbtUp.Checked then
    begin
      for I := 0 to memo.SearchEngine.ResultCount - 1 do
        if memo.SearchEngine.Results[I] > selstart then
        begin
          Count := I;
          Start := I - 1;
          Break;
        end;
      if (Count = 0) and (Start = 0) then
      begin
        Count := memo.SearchEngine.ResultCount;
        Start := Count - 1;
      end;
    end
    else
    begin
      for I := 0 to memo.SearchEngine.ResultCount - 1 do
        if memo.SearchEngine.Results[I] > selend then
        begin
          Count := memo.SearchEngine.ResultCount - I;
          Start := I;
          Break;
        end;
    end;
  end
  else if RdbtUp.Checked then
  begin
    for I := 0 to memo.SearchEngine.ResultCount - 1 do
      if memo.SearchEngine.Results[I] > selstart then
      begin
        Start := I - 1;
        Break;
      end;
    if Start < 0 then
      Start := Count - 1;
  end;
  if Count = 0 then
  begin
    AlphaBlend := False;
    AlphaBlendValue := 255;
    MessageBox(Handle, PChar(Format(STR_FRM_FIND[30], [search])),
      PChar(StringReplace(STR_FRM_FIND[2], '&', '', [])), MB_OK);
    Exit;
  end;
  Index := -1;
  if RdbtDown.Checked then
  begin
    for I := Start to memo.SearchEngine.ResultCount - 1 do
      if memo.SearchEngine.Results[I] > selend then
      begin
        Index := I;
        Break;
      end;
  end
  else
    Index := Start;
  if Index = -1 then
    Index := Start;
  I := memo.SearchEngine.Results[Index];
  lastlength := memo.SearchEngine.Lengths[Index];
  FrmFalconMain.SelectFromSelStart(I - 1, lastlength, memo);
  frm.LastSearch.Search := search;
  frm.LastSearch.DiffCase := ChbDiffCase.Checked;
  frm.LastSearch.FullWord := ChbFullWord.Checked;
  if ChbTransp.Checked then
  begin
    pt := memo.RowColumnToPixels(memo.BufferToDisplayPos(memo.CaretXY));
    pt := memo.ClientToScreen(pt);
    GetWindowRect(Handle, rect);
    if PtInRect(rect, pt) = TRUE then
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
  sheet: TSourceFileSheet;
  memo: TSynEdit;
  search, replace, text: string;
  selstart: Integer;
  sopt: TSynSearchOptions;
begin
  if not frm.GetActiveSheet(sheet) then
    Exit;
  UpdateReplaceHistoryList(CboReplace.Text);
  memo := sheet.Memo;
  search := CboFind.Text;
  replace := CboReplace.Text;
  if RGrpSearchMode.ItemIndex = 1 then //resolve \n \r \t
    search := ResolveStr(search);
  if RGrpSearchMode.ItemIndex = 1 then //resolve \n \r \t
    replace := ResolveStr(replace);
  if RGrpSearchMode.ItemIndex = 2 then
    memo.SearchEngine := FrmFalconMain.EditorRegexSearch
  else
    memo.SearchEngine := FrmFalconMain.EditorSearch;
  sopt := [];
  if ChbCircSearch.Checked then
    sopt := sopt + [ssoEntireScope];
  if ChbDiffCase.Checked then
    sopt := sopt + [ssoMatchCase];
  if ChbFullWord.Checked then
    sopt := sopt + [ssoWholeWord];
  memo.SearchEngine.Options := sopt;
  //compare and replace **********
  text := memo.SelText;
  memo.SearchEngine.Pattern := search;
  memo.SearchEngine.FindAll(text);
  if memo.SearchEngine.ResultCount = 1 then
  begin
    replace := memo.SearchEngine.Replace(text, replace);
    selstart := memo.SelStart;
    memo.SelText := replace;
    memo.SelStart := selstart;
    memo.SelLength := Length(replace);
  end;
  //******************************
  BtnFindClick(Sender);
end;

procedure TFrmFind.BtnReplAllClick(Sender: TObject);
var
  sheet: TSourceFileSheet;
  memo: TSynEdit;
  search, replace: string;
  Count: Integer;
  sopt: TSynSearchOptions;
begin
  if not frm.GetActiveSheet(sheet) then
    Exit;
  UpdateReplaceHistoryList(CboReplace.Text);
  memo := sheet.Memo;
  search := CboFind.Text;
  replace := CboReplace.Text;
  if RGrpSearchMode.ItemIndex = 1 then //resolve \n \r \t
    search := ResolveStr(search);
  if RGrpSearchMode.ItemIndex = 1 then //resolve \n \r \t
    replace := ResolveStr(replace);

  sopt := [ssoReplaceAll];
  if ChbReplSel.Checked then
    sopt := sopt + [ssoSelectedOnly]
  else if ChbCircSearch.Checked then
    sopt := sopt + [ssoEntireScope];
  if ChbDiffCase.Checked then
    sopt := sopt + [ssoMatchCase];
  if ChbFullWord.Checked then
    sopt := sopt + [ssoWholeWord];
  if ChbCircSearch.Checked then
    sopt := sopt + [ssoEntireScope];

  Count := memo.SearchReplace(search, replace, sopt);
  MessageBox(Handle, PChar(Format(STR_FRM_FIND[31], [Count])),
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
