unit UFrmCodeTemplates;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, UEditor, StdCtrls, AutoComplete,
  USourceFile;

type
  TFrmCodeTemplates = class(TForm)
    GroupBox1: TGroupBox;
    BtnOk: TButton;
    Label1: TLabel;
    Label2: TLabel;
    BtnAdd: TSpeedButton;
    BtnRem: TSpeedButton;
    BtnEdit: TSpeedButton;
    ListViewTemplates: TListView;
    procedure FormCreate(Sender: TObject);
    procedure ListViewTemplatesSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListViewTemplatesAdvancedCustomDrawItem(
      Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
      Stage: TCustomDrawStage; var DefaultDraw: Boolean);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    function IndexOf(const ctiName: string; skip: Integer = -1): Integer;
    procedure OkButtonEvent(Sender: TObject; const Name, Description: string;
      Data: Pointer; var Abort: Boolean);
    procedure MakeCompletion(List: TStrings);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure ListViewTemplatesDeletion(Sender: TObject; Item: TListItem);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnRemClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    SynTemplates: TEditor;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    AutoComplete: TSynAutoCompleteTemplate;
    CodeTemplateFileName: string;
    procedure UpdateLangNow;
  end;

  TCodeTemplateItem = class
  public
    ReadOnly: Boolean;
      Name: string;
    Comment: string;
    Code: string;
  end;

var
  FrmCodeTemplates: TFrmCodeTemplates;

implementation

uses UFrmMain, UFrmPromptCodeTemplate, ULanguages, UUtils;

{$R *.dfm}

procedure TFrmCodeTemplates.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if ParentWindow <> 0 then
  begin
    Params.Style := Params.Style and not WS_CHILD;
    if BorderStyle = bsNone then
      Params.Style := Params.Style or WS_POPUP;
  end;
end;

procedure TFrmCodeTemplates.UpdateLangNow;
begin
  Caption := STR_FRM_EDITOR_OPT[134];
  GroupBox1.Caption := STR_FRM_EDITOR_OPT[134];
  Label1.Caption := STR_FRM_CODE_TEMPL[1];
  ListViewTemplates.Columns.Items[0].Caption := STR_FRM_PROMPT_CODE[1];
  ListViewTemplates.Columns.Items[1].Caption := STR_FRM_PROMPT_CODE[2];
  BtnAdd.Hint := STR_FRM_PROP[34];
  BtnRem.Hint := STR_FRM_PROP[35];
  BtnEdit.Hint := STR_FRM_PROP[56];
  Label2.Caption := STR_FRM_CODE_TEMPL[2];
  BtnOk.Caption := STR_FRM_PROP[14];
end;

procedure TFrmCodeTemplates.FormCreate(Sender: TObject);
var
  I: Integer;
  CTI: TCodeTemplateItem;
  Item: TListItem;
  Rs: TResourceStream;
begin
  SetExplorerTheme(ListViewTemplates.Handle);
  AutoComplete := TSynAutoCompleteTemplate.Create(Self);
  SynTemplates := TEditor.Create(GroupBox1);
  SynTemplates.Parent := GroupBox1;
  SynTemplates.Left := Label2.Left;
  SynTemplates.Top := Label2.Top + Label2.Height + Label2.Left div 2;
  SynTemplates.Width := GroupBox1.Width - 2 * Label2.Left;
  SynTemplates.Height := GroupBox1.Height - SynTemplates.Top - Label2.Left;
  SynTemplates.TabOrder := 1;
  SynTemplates.Highlighter := FrmFalconMain.CppHighligher;
  TSourceFileSheet.UpdateEditor(SynTemplates);
  SynTemplates.Folding := False;
  SynTemplates.ShowLineNumber := False;
  Rs := TResourceStream.Create(HInstance, 'AUTOCOMPLETE', RT_RCDATA);
  Rs.Position := 0;
  AutoComplete.AutoCompleteList.LoadFromStream(Rs);
  Rs.Free;
  for I := 0 to AutoComplete.Completions.Count - 1 do
  begin
    CTI := TCodeTemplateItem.Create;
    CTI.ReadOnly := True;
    CTI.Name := AutoComplete.Completions.Strings[I];
    CTI.Comment := AutoComplete.CompletionComments.Strings[I];
    CTI.Code := AutoComplete.CompletionValues.Strings[I];
    Item := ListViewTemplates.Items.Add;
    Item.Caption := CTI.Name;
    Item.SubItems.Add(CTI.Comment);
    Item.Data := CTI;
  end;
  AutoComplete.AutoCompleteList.Clear;

  if FileExists(CodeTemplateFileName) then
    AutoComplete.AutoCompleteList.LoadFromFile(CodeTemplateFileName);
  for I := 0 to AutoComplete.Completions.Count - 1 do
  begin
    CTI := TCodeTemplateItem.Create;
    CTI.Name := AutoComplete.Completions.Strings[I];
    CTI.Comment := AutoComplete.CompletionComments.Strings[I];
    CTI.Code := AutoComplete.CompletionValues.Strings[I];
    Item := ListViewTemplates.Items.Add;
    Item.Caption := CTI.Name;
    Item.SubItems.Add(CTI.Comment);
    Item.Data := CTI;
  end;
  if ListViewTemplates.Items.Count > 0 then
    ListViewTemplates.Items[0].Selected := True;
  UpdateLangNow;
end;

procedure TFrmCodeTemplates.ListViewTemplatesSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var
  CTI: TCodeTemplateItem;
begin
  if not Selected then
  begin
    BtnRem.Enabled := False;
    BtnEdit.Enabled := False;
    Exit;
  end;
  CTI := TCodeTemplateItem(Item.Data);
  BtnRem.Enabled := not CTI.ReadOnly;
  BtnEdit.Enabled := not CTI.ReadOnly;
  SynTemplates.Lines.Text := CTI.Code;
end;

procedure TFrmCodeTemplates.FormDestroy(Sender: TObject);
begin
  FrmCodeTemplates := nil;
end;

procedure TFrmCodeTemplates.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmCodeTemplates.ListViewTemplatesAdvancedCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: Boolean);
var
  CTI: TCodeTemplateItem;
begin
  CTI := TCodeTemplateItem(Item.Data);
  if CTI.ReadOnly then
    Sender.Canvas.Font.Color := clGray
  //else
  //  Sender.Canvas.Brush.Color := ListViewTemplates.Color;
end;

procedure TFrmCodeTemplates.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #27) then
  begin
    Key := #0;
    Close;
  end;
end;

function TFrmCodeTemplates.IndexOf(const ctiName: string; skip: Integer = -1): Integer;
var
  I: Integer;
  CTI: TCodeTemplateItem;
begin
  for I := 0 to ListViewTemplates.Items.Count - 1 do
  begin
    if skip = I then
      Continue;
    CTI := TCodeTemplateItem(ListViewTemplates.Items[I].Data);
    if CTI.Name = ctiName then
    begin
      Result := I;
      Exit;
    end;
  end;
  Result := -1;
end;

procedure TFrmCodeTemplates.OkButtonEvent(Sender: TObject; const Name, Description: string;
  Data: Pointer; var Abort: Boolean);
begin
  if Length(Name) = 0 then
  begin
    Abort := True;
    MessageBox(TWinControl(Sender).Handle, PChar(STR_FRM_CODE_TEMPL[3]),
      PChar(STR_FRM_EDITOR_OPT[134]), MB_ICONEXCLAMATION);
    Exit;
  end;
  if Assigned(Data) then
  begin
    if IndexOf(Name, IndexOf(TCodeTemplateItem(Data).Name)) > -1 then
    begin
      Abort := True;
      MessageBox(TWinControl(Sender).Handle, PChar(STR_FRM_CODE_TEMPL[4]),
        PChar(STR_FRM_EDITOR_OPT[134]), MB_ICONEXCLAMATION);
    end;
  end
  else
  begin
    if IndexOf(Name) > -1 then
    begin
      Abort := True;
      MessageBox(TWinControl(Sender).Handle, PChar(STR_FRM_CODE_TEMPL[4]),
        PChar(STR_FRM_EDITOR_OPT[134]), MB_ICONEXCLAMATION);
    end;
  end;
end;

procedure TFrmCodeTemplates.MakeCompletion(List: TStrings);
var
  I: Integer;
begin
  for I := 0 to AutoComplete.Completions.Count - 1 do
  begin
    List.Add('[' + AutoComplete.Completions.Strings[I] + ' | ' +
      AutoComplete.CompletionComments.Strings[I] + ']');
    List.Append(AutoComplete.CompletionValues.Strings[I]);
  end;
end;

procedure TFrmCodeTemplates.BtnAddClick(Sender: TObject);
var
  CTI: TCodeTemplateItem;
  Item: TListItem;
  ctiName, ctiDesc: string;
  List: TStrings;
begin
  if PromptDialog(Handle, STR_FRM_CODE_TEMPL[5], ctiName, ctiDesc, nil, OkButtonEvent) then
  begin
    CTI := TCodeTemplateItem.Create;
    CTI.Name := ctiName;
    CTI.Comment := ctiDesc;
    CTI.Code := SynTemplates.Lines.Text;
    AutoComplete.AddCompletion(CTI.Name, CTI.Code, CTI.Comment);
    FrmFalconMain.AutoComplete.AddCompletion(CTI.Name, CTI.Code, CTI.Comment);
    List := TStringList.Create;
    MakeCompletion(List);
    try
      List.SaveToFile(CodeTemplateFileName);
    finally
      List.Free;
    end;
    Item := ListViewTemplates.Items.Add;
    Item.Caption := CTI.Name;
    Item.SubItems.Add(CTI.Comment);
    Item.Data := CTI;
  end;
end;

procedure TFrmCodeTemplates.BtnEditClick(Sender: TObject);
var
  CTI: TCodeTemplateItem;
  Item: TListItem;
  ctiName, ctiDesc: string;
  I: integer;
  List: TStrings;
begin
  Item := ListViewTemplates.Selected;
  CTI := TCodeTemplateItem(Item.Data);
  ctiName := CTI.Name;
  ctiDesc := CTI.Comment;
  if PromptDialog(Handle, STR_FRM_CODE_TEMPL[6], ctiName, ctiDesc, CTI, OkButtonEvent) then
  begin
    I := AutoComplete.Completions.IndexOf(CTI.Name);
    AutoComplete.Completions.Strings[I] := ctiName;
    AutoComplete.CompletionComments.Strings[I] := ctiDesc;
    AutoComplete.CompletionValues.Strings[I] := SynTemplates.Lines.Text;
    //update autocompletion of Main Form
    I := FrmFalconMain.AutoComplete.Completions.IndexOf(CTI.Name);
    if I > -1 then
    begin
      FrmFalconMain.AutoComplete.Completions.Strings[I] := ctiName;
      FrmFalconMain.AutoComplete.CompletionComments.Strings[I] := ctiDesc;
      FrmFalconMain.AutoComplete.CompletionValues.Strings[I] := SynTemplates.Lines.Text;
    end;

    List := TStringList.Create;
    MakeCompletion(List);
    try
      List.SaveToFile(CodeTemplateFileName);
    finally
      List.Free;
    end;
    CTI.Name := ctiName;
    CTI.Comment := ctiDesc;
    CTI.Code := SynTemplates.Lines.Text;
    Item.Caption := CTI.Name;
    Item.SubItems.Strings[0] := CTI.Comment;
  end;
end;

procedure TFrmCodeTemplates.ListViewTemplatesDeletion(Sender: TObject;
  Item: TListItem);
begin
  TCodeTemplateItem(Item.Data).Free;
end;

procedure TFrmCodeTemplates.BtnOkClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmCodeTemplates.BtnRemClick(Sender: TObject);
var
  I: integer;
  List: TStrings;
  Item: TListItem;
begin
  Item := ListViewTemplates.Selected;
  I := AutoComplete.Completions.IndexOf(TCodeTemplateItem(Item.Data).Name);
  AutoComplete.Completions.Delete(I);
  AutoComplete.CompletionComments.Delete(I);
  AutoComplete.CompletionValues.Delete(I);
  //update autocompletion of Main Form
  I := FrmFalconMain.AutoComplete.Completions.IndexOf(TCodeTemplateItem(Item.Data).Name);
  if I > -1 then
  begin
    FrmFalconMain.AutoComplete.Completions.Delete(I);
    FrmFalconMain.AutoComplete.CompletionComments.Delete(I);
    FrmFalconMain.AutoComplete.CompletionValues.Delete(I);
  end;

  List := TStringList.Create;
  MakeCompletion(List);
  try
    List.SaveToFile(CodeTemplateFileName);
  finally
    List.Free;
  end;
  Item.Delete;
end;

procedure TFrmCodeTemplates.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close
  else if (Key = VK_RETURN) and (Shift = [ssCtrl]) then
    BtnOk.Click;
end;

end.
