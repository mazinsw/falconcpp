unit UFrmGotoFunction;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, UEditor;

type
  TFormGotoFunction = class(TForm)
    PanelFind: TPanel;
    ListViewFunctions: TListView;
    EditFuncName: TEdit;
    procedure EditFuncNameKeyPress(Sender: TObject; var Key: Char);
    procedure EditFuncNameChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditFuncNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListViewFunctionsDblClick(Sender: TObject);
  private
    { Private declarations }
    tokenList: TStrings;
    procedure ClearTokenList;
    procedure SelectItem(Index: Integer);
    procedure SelectFunction(Index: Integer);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    procedure Fill(List: TStrings);
    procedure Match(const S: string);
    procedure UpdateLangNow;
  end;

var
  FormGotoFunction: TFormGotoFunction;

implementation

uses UFrmMain, TokenList, TokenFile, TokenUtils, USourceFile, ULanguages;

{$R *.dfm}

procedure TFormGotoFunction.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if ParentWindow <> 0 then
  begin
    Params.Style := Params.Style and not WS_CHILD;
    if BorderStyle = bsNone then
      Params.Style := Params.Style or WS_POPUP;
  end;
end;

procedure TFormGotoFunction.UpdateLangNow;
begin
  Caption := STR_FRM_GOTOFUNC[1];
  EditFuncName.TextHint := STR_FRM_GOTOFUNC[2];
  ListViewFunctions.Columns.Items[0].Caption := STR_FRM_GOTOFUNC[3];
  ListViewFunctions.Columns.Items[1].Caption := STR_FRM_GOTOFUNC[4];
  ListViewFunctions.Columns.Items[2].Caption := STR_FRM_GOTOFUNC[5];
  ListViewFunctions.Columns.Items[3].Caption := STR_FRM_GOTOFUNC[6];
end;

procedure TFormGotoFunction.ClearTokenList;
var
  I: Integer;
  Token: TTokenClass;
begin
  for I := 0 to tokenList.Count - 1 do
  begin
    Token := TTokenClass(tokenList.Objects[I]);
    Token.Free;
  end;
  tokenList.Clear;
end;

procedure TFormGotoFunction.Fill(List: TStrings);
var
  I: Integer;
  Item: TListItem;
  Token: TTokenClass;
  TokenFile: TTokenFile;
begin
  ClearTokenList;
  tokenList.Assign(List);
  ListViewFunctions.Clear;
  for I := 0 to tokenList.Count - 1 do
  begin
    Token := TTokenClass(tokenList.Objects[I]);
    TokenFile := TTokenFile(Token.Owner);
    if Assigned(TokenFile) then
      tokenList.Strings[I] := TokenFile.FileName;
    Item := ListViewFunctions.Items.Add;
    Item.Caption := GetFuncScope(Token) + Token.Name;
    Item.Data := Token;
    Item.ImageIndex := GetTokenImageIndex(Token, TreeImages);
    Item.SubItems.Add(Token.Flag);
    Item.SubItems.Add(IntToStr(Token.SelLine));
    Item.SubItems.Add(ExtractFileName(tokenList.Strings[I]));
  end;
  if ListViewFunctions.Items.Count > 0 then
    SelectItem(0);
end;

procedure TFormGotoFunction.Match(const S: string);
var
  I: Integer;
  Item: TListItem;
  Token: TTokenClass;
//  List: TStrings;
begin
  //List := TStringList.Create;
  ListViewFunctions.Clear;
  for I := 0 to tokenList.Count - 1 do
  begin
    Token := TTokenClass(tokenList.Objects[I]);
    if (S <> '') and (Pos(UpperCase(S), UpperCase(Token.Name)) = 0) then
      Continue;
    Item := ListViewFunctions.Items.Add;
    Item.Caption := GetFuncScope(Token) + Token.Name;
    Item.Data := Token;
    Item.ImageIndex := GetTokenImageIndex(Token, TreeImages);
    Item.SubItems.Add(Token.Flag);
    Item.SubItems.Add(IntToStr(Token.SelLine));
    Item.SubItems.Add(ExtractFileName(tokenList.Strings[I]));
  end;
  if ListViewFunctions.Items.Count > 0 then
    SelectItem(0);
  //List.Free;
end;

procedure TFormGotoFunction.EditFuncNameKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    SelectFunction(ListViewFunctions.ItemIndex);
  end;
  if (Key = #27) then
    Key := #0;
end;

procedure TFormGotoFunction.EditFuncNameChange(Sender: TObject);
begin
  Match(Trim(EditFuncName.Text));
end;

procedure TFormGotoFunction.FormDestroy(Sender: TObject);
begin
  ClearTokenList;
  tokenList.Free;
  FormGotoFunction := nil;
end;

procedure TFormGotoFunction.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFormGotoFunction.FormCreate(Sender: TObject);
begin
  tokenList := TStringList.Create;
  UpdateLangNow;
end;

procedure TFormGotoFunction.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TFormGotoFunction.SelectItem(Index: Integer);
var
  Item: TListItem;
begin
  ListViewFunctions.ItemIndex := Index;
  Item := ListViewFunctions.Items.Item[Index];
  Item.Selected := True;
  Item.Focused := True;
  ListViewFunctions.Scroll(0, Item.Top - (ListViewFunctions.Height div 2));
end;

procedure TFormGotoFunction.EditFuncNameKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  Index: Integer;
begin
  Index := ListViewFunctions.ItemIndex;
  if Key = VK_UP then
  begin
    Key := 0;
    if Index < 0 then
      Index := 1;
    if Index <= 0 then
      Exit;
    Dec(Index);
    SelectItem(Index);
  end
  else if Key = VK_DOWN then
  begin
    Key := 0;
    Inc(Index);
    if (Index >= ListViewFunctions.Items.Count) and
      (ListViewFunctions.Items.Count > 0) then
      Exit;
    SelectItem(Index);
  end;
end;

procedure TFormGotoFunction.SelectFunction(Index: Integer);
var
  Item: TListItem;
  Token: TTokenClass;
  fileprop: TSourceFile;
  sheet: TSourceFileSheet;
  Buffer: TBufferCoord;
begin
  if (Index < 0) or (Index >= ListViewFunctions.Items.Count) then
    Exit;
  Item := ListViewFunctions.Items.Item[Index];
  Token := TTokenClass(Item.Data);
  Token := GetTokenByName(Token, 'Scope', tkScope);
  if Assigned(Token) and Assigned(Token.Owner) and
    Assigned(TTokenFile(Token.Owner).Data) then
  begin
    fileprop := TSourceFile(TTokenFile(Token.Owner).Data);
    sheet := fileprop.Edit;
    Buffer := sheet.Editor.CharIndexToRowCol(Token.SelStart);
    FrmFalconMain.GotoLineAndAlignCenter(sheet.Editor, Buffer.Line, Buffer.Char);
  end;
  Close;
end;

procedure TFormGotoFunction.ListViewFunctionsDblClick(Sender: TObject);
begin
  SelectFunction(ListViewFunctions.ItemIndex);
end;

end.
