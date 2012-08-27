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
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

var
  FrmRemove: TFrmRemove;

implementation



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

procedure TFrmRemove.SetProject(Proj: TProjectFile);
var
  I: Integer;
  Files: TStrings;
  Item: TListItem;
begin
  Files := TStringList.Create;
  proj.GetFiles(Files);
  for I := 0 to Files.Count - 1 do
  begin
    Item := FileList.Items.Add;
    Item.Caption := TSourceFile(Files.Objects[I]).Name;
    Item.SubItems.Add(TSourceFile(Files.Objects[I]).FileName);
    Item.ImageIndex := TSourceFile(Files.Objects[I]).Node.ImageIndex;
    Item.Data := Files.Objects[I];
  end;
  Files.Free;
end;

procedure TFrmRemove.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmRemove.BtnOkClick(Sender: TObject);
begin
  //Save;
  Close;
end;

procedure TFrmRemove.BtnApplyClick(Sender: TObject);
begin
  //Save;
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

end.
