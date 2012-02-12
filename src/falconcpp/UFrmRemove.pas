unit UFrmRemove;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ComCtrls, StdCtrls, UFileProperty;

type
  TFrmRemove = class(TForm)
    BtnOk: TButton;
    BtnCancel: TButton;
    BtnApply: TButton;
    FileList: TListView;
    SBtnRem: TSpeedButton;
    SBtnUndo: TSpeedButton;
    SBtnRedo: TSpeedButton;
    procedure SetProject(Proj: TProjectProperty);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnApplyClick(Sender: TObject);
    procedure FileListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmRemove: TFrmRemove;

implementation

uses UFrmMain;

{$R *.dfm}

procedure TFrmRemove.SetProject(Proj: TProjectProperty);
var
  I: Integer;
  Files: TStrings;
  Item: TListItem;
begin
  Files := proj.GetFiles;
  for I:= 0 to Pred(Files.Count) do
  begin
    Item := FileList.Items.Add;
    Item.Caption := TFileProperty(Files.Objects[I]).Caption;
    Item.SubItems.Add(TFileProperty(Files.Objects[I]).GetCompleteFileName);
    Item.ImageIndex := TFileProperty(Files.Objects[I]).Node.ImageIndex;
    Item.Data := Files.Objects[I];
  end;
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
  if Key = VK_ESCAPE then Close;
end;

end.
