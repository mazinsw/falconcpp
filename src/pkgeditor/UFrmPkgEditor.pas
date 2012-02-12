unit UFrmPkgEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Gradient, ExtCtrls, StdCtrls, XPMan, ComCtrls, ToolWin, ImgList,
  FormEffect;

type
  TFrmPkgEditor = class(TForm)
    XPManifest1: TXPManifest;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Panel2: TPanel;
    ImageListAddDel: TImageList;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    ListView1: TListView;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolBar2: TToolBar;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ListView2: TListView;
    ListView4: TListView;
    ListView6: TListView;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ImageListToolbar: TImageList;
    ToolBar3: TToolBar;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolBar4: TToolBar;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolBar5: TToolBar;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolBar6: TToolBar;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolBar7: TToolBar;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ImageListCategory: TImageList;
    ListView5: TListView;
    ToolButton18: TToolButton;
    ListView3: TListView;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPkgEditor: TFrmPkgEditor;

implementation

{$R *.dfm}
{$R resources.res}

procedure TFrmPkgEditor.FormCreate(Sender: TObject);
begin
  //DoubleBuffered := true;
  //Panel1.DoubleBuffered := True;
  //GroupBox1.DoubleBuffered := True;
  ConvertTo32BitImageList(ImageListAddDel);
  AddImages(ImageListAddDel, 'ADDDEL');
  ConvertTo32BitImageList(ImageListToolbar);
  AddImages(ImageListToolbar, 'TOOLBARIMG');
  ConvertTo32BitImageList(ImageListCategory);
  AddImages(ImageListCategory, 'CONTENTS');
end;

end.
