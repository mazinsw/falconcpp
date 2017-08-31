unit UFrmRemove;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ComCtrls, StdCtrls, USourceFile, ExtCtrls;

type
  TFrmRemove = class(TForm)
    SBtnRem: TSpeedButton;
    SBtnUndo: TSpeedButton;
    SBtnRedo: TSpeedButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    FileList: TListView;
    Panel4: TPanel;
    BtnOk: TButton;
    BtnCancel: TButton;
    BtnApply: TButton;
    procedure SetProject(Proj: TProjectFile);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnApplyClick(Sender: TObject);
    procedure FileListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SBtnRemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SBtnUndoClick(Sender: TObject);
    procedure SBtnRedoClick(Sender: TObject);
    procedure FileListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    HistoryList: TList;
    HistoryPos: Integer;
    procedure AddItem(SourceFile: TSourceFile);
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

var
  FrmRemove: TFrmRemove;

implementation

uses
  UFrmMain, UUtils;

{$R *.dfm}

procedure TFrmRemove.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if ParentWindow <> 0 then
  begin
    Params.Style := Params.Style and not WS_CHILD;
    if BorderStyle = bsNone then
      Params.Style := Params.Style or WS_POPUP;
  end;
end;

procedure TFrmRemove.AddItem(SourceFile: TSourceFile);
var
  Item: TListItem;
begin
  Item := FileList.Items.Add;
  Item.Caption := SourceFile.Name;
  Item.SubItems.Add(SourceFile.FileName);
  Item.ImageIndex := SourceFile.Node.ImageIndex;
  Item.Data := SourceFile;
end;

procedure TFrmRemove.SetProject(Proj: TProjectFile);
var
  I: Integer;
  Files: TStrings;
begin
  Files := TStringList.Create;
  proj.GetSources(Files, FILES_TYPES);
  for I := 0 to Files.Count - 1 do
    AddItem(TSourceFile(Files.Objects[I]));
  Files.Free;
end;

procedure TFrmRemove.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmRemove.BtnOkClick(Sender: TObject);
begin
  BtnApply.Click;
  Close;
end;

procedure TFrmRemove.BtnApplyClick(Sender: TObject);
var
  I: Integer;
begin
  for I := HistoryPos downto 0 do
  begin
    if FrmFalconMain.RemoveFile(Handle, TSourceFile(HistoryList.Items[I])) then
    begin
      Dec(HistoryPos);
      HistoryList.Delete(I);
    end;
  end;
  SBtnUndo.Enabled := HistoryPos >= 0;
  SBtnRedo.Enabled := HistoryPos < HistoryList.Count - 1;
  BtnApply.Enabled := HistoryPos >= 0;
end;

procedure TFrmRemove.FileListSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  SBtnRem.Enabled := Selected;
end;

procedure TFrmRemove.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TFrmRemove.SBtnRemClick(Sender: TObject);
var
  I: Integer;
  Item: TListItem;
begin
  // remove redo items
  for I := HistoryList.Count - 1 downto HistoryPos + 1 do
    HistoryList.Delete(I);
  for I := FileList.Items.Count - 1 downto 0 do
  begin
    if not FileList.Items.Item[I].Selected then
      Continue;
    Item := FileList.Items.Item[I];
    Inc(HistoryPos);
    HistoryList.Add(Item.Data);
    Item.Delete;
  end;
  SBtnRedo.Enabled := False;
  SBtnUndo.Enabled := True;
  BtnApply.Enabled := HistoryPos >= 0;
end;

procedure TFrmRemove.FormCreate(Sender: TObject);
begin
  HistoryPos := -1;
  HistoryList := TList.Create;
  SetExplorerTheme(FileList.Handle);
end;

procedure TFrmRemove.FormDestroy(Sender: TObject);
begin
  HistoryList.Free;
end;

procedure TFrmRemove.SBtnUndoClick(Sender: TObject);
begin
  // undo remove
  AddItem(TSourceFile(HistoryList.Items[HistoryPos]));
  Dec(HistoryPos);
  SBtnUndo.Enabled := HistoryPos >= 0;
  SBtnRedo.Enabled := HistoryPos < HistoryList.Count - 1;
  BtnApply.Enabled := HistoryPos >= 0;
end;

procedure TFrmRemove.SBtnRedoClick(Sender: TObject);
var
  I: Integer;
begin
  Inc(HistoryPos);
  for I := 0 to FileList.Items.Count - 1 do
  begin
    if FileList.Items.Item[I].Data = HistoryList.Items[HistoryPos] then
    begin
      FileList.Items.Item[I].Delete;
      Break;
    end;
  end;
  SBtnUndo.Enabled := True;
  SBtnRedo.Enabled := HistoryPos < HistoryList.Count - 1;
  BtnApply.Enabled := HistoryPos >= 0;
end;

procedure TFrmRemove.FileListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) and SBtnRem.Enabled then
    SBtnRem.Click;
end;

end.
