unit UFrmPkgMan;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Graphics,
  Dialogs, Menus, ComCtrls, ToolWin, ImgList, StdCtrls, PNGImage,
  RichEditViewer, FormEffect, IniFiles, ShellApi, ExtCtrls, Clipbrd;

const
  WM_RELOADPKG  = WM_USER + $0112;

type
  TFrmPkgMan = class(TForm)
    MainMenu1: TMainMenu;
    Packages1: TMenuItem;
    Install1: TMenuItem;
    Uninstall1: TMenuItem;
    N1: TMenuItem;
    Reload1: TMenuItem;
    N2: TMenuItem;
    Quit1: TMenuItem;
    Check1: TMenuItem;
    View1: TMenuItem;
    toolbarchk: TMenuItem;
    Details1: TMenuItem;
    Help1: TMenuItem;
    Help2: TMenuItem;
    N3: TMenuItem;
    About1: TMenuItem;
    Statusbar1: TMenuItem;
    StatusBar: TStatusBar;
    InfoPanel: TPanel;
    PanelList: TPanel;
    ToolBar: TToolBar;
    TbInstall: TToolButton;
    TbUninstall: TToolButton;
    ToolButton3: TToolButton;
    TbReload: TToolButton;
    TbCheck: TToolButton;
    ToolButton6: TToolButton;
    TbHelp: TToolButton;
    TbAbout: TToolButton;
    ToolButton9: TToolButton;
    TbExit: TToolButton;
    Splitter1: TSplitter;
    PkgList: TListView;
    PageControl: TPageControl;
    TsInfo: TTabSheet;
    TsFile: TTabSheet;
    FileList: TTreeView;
    HotImgListToolbar: TImageList;
    ImgListMenu: TImageList;
    PanelWsite: TPanel;
    Label2: TLabel;
    PanelPkgname: TPanel;
    Label1: TLabel;
    EdName: TEdit;
    PanelVer: TPanel;
    Label4: TLabel;
    EdVer: TEdit;
    ImgListToolbar: TImageList;
    PanelLblDesc: TPanel;
    Label5: TLabel;
    TextDesc: TRichEditViewer;
    ImgPkgList: TImageList;
    LblSite: TLabel;
    PopupMenu1: TPopupMenu;
    OpenFolder1: TMenuItem;
    CopyFileName1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure PkgListProc(var Msg: TMessage);
    procedure ReloadPackages(var Message: TMessage); message WM_RELOADPKG;
    procedure LoadPackages;
    procedure TsInfoResize(Sender: TObject);
    procedure InstallClick(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure ViewControlsClick(Sender: TObject);
    procedure ReloadClick(Sender: TObject);
    procedure CreateTree(Files: TStrings; Expanded: Boolean = False);
    procedure PkgListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure PkgListDeletion(Sender: TObject; Item: TListItem);
    procedure LblSiteClick(Sender: TObject);
    procedure TbCheckClick(Sender: TObject);
    procedure PkgListMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TbUninstallClick(Sender: TObject);
    procedure TbHelpClick(Sender: TObject);
    procedure CopyFileName1Click(Sender: TObject);
    procedure FileListChange(Sender: TObject; Node: TTreeNode);
    procedure OpenFolder1Click(Sender: TObject);
  private
    { Private declarations }
    PkgListWndProc: TWndMethod;
    function GetPathFromNode(Node: TTreeNode): string;
  public
    { Public declarations }
    function PackageInstalled(const Name, Version: string): Boolean;
  end;

  TPkgItem = class
  public
    Name: String;
    Version: String;
    Description: String;
    WebSiteCaption: String;
    WebSite: String;
    Dependencies: String;
    Files: TStrings;
    constructor Create;
    destructor Destroy; override;
  end;


var
  FrmPkgMan: TFrmPkgMan;

implementation

uses UInstaller, UFrmWizard, UFraFnsh, UUninstaller, UFrmPkgDownload,
  UFrmHelp;

{$R *.dfm}

constructor TPkgItem.Create;
begin
  inherited Create;
  Files := TStringList.Create;
end;

destructor TPkgItem.Destroy;
begin
  Files.Free;
  inherited Destroy;
end;

procedure addimages(imglist: TImageList; resname: String);
var
  Rs: TResourceStream;
  png: TPNGObject;
  bmp: TBitmap;
begin
  Rs := TResourceStream.Create(HInstance, resname, RT_RCDATA);
  Rs.Position := 0;
  png := TPNGObject.Create;
  png.LoadFromStream(Rs);
  bmp := PNGToBMP32(png);
  imglist.AddMasked(bmp, clNone);
  bmp.Free;
  Rs.Free;
  png.Free;
end;

procedure TFrmPkgMan.CreateTree(Files: TStrings; Expanded: Boolean = False);

  function GetImgIndex(FileName: String): Integer;
  var
    Ext: String;
  begin
    Result := 1;
    Ext := UpperCase(ExtractFileExt(FileName));
    if Ext = '.HTML' then
      Result := 2
    else if Ext = '.DLL' then
      Result := 3
    else if Ext = '.EXE' then
      Result := 4
    else if Ext = '.FTM' then
      Result := 5
    else if Ext = '.H' then
      Result := 6
    else if (Ext = '.A') or (Ext = '.O') then
      Result := 7
    else if Ext = '.CHM' then
      Result := 8;
  end;

  function GetParentNode(FileName: String): TTreeNode;

    function CreateNode(Prnt: TTreeNode; NCaption: String): TTreeNode;
    var
      I: Integer;
    begin
      if Assigned(Prnt) then
      begin
        for I:= 0 to Pred(Prnt.Count) do
        begin
          if Prnt.Item[I].Text = NCaption then
          begin
            Result := Prnt.Item[I];
            Exit;
          end;
        end;
        Result := FileList.Items.AddChild(Prnt, NCaption);
      end
      else
      begin
        for I:= 0 to Pred(FileList.Items.Count) do
        begin
          if FileList.Items.Item[I].Level = 0 then
          begin
            if FileList.Items.Item[I].Text = NCaption then
            begin
              Result := FileList.Items.Item[I];
              Exit;
            end;
          end;
        end;
        Result := FileList.Items.AddChild(nil, NCaption);
      end;
    end;

  var
    Capt, Rest: String;
    I: Integer;
  begin
    Rest := FileName;
    Capt := FileName;
    Result := nil;
    repeat
      I := Pos('\', Capt);
      if (I > 0) then
      begin
        Capt := Copy(Capt, 1, I - 1);
        Delete(Rest, 1, I);
        Result := CreateNode(Result, Capt);
        Capt := Rest;
      end;
    until(I = 0);
  end;

var
  Node, LNode: TTreeNode;
  I: Integer;
  Last: String;
begin
  Last := '';
  LNode := nil;
  for I:= 0 to Pred(Files.Count) do
  begin
    if not (ExtractFilePath(Files.Strings[I]) = Last) then
      LNode := GetParentNode(Files.Strings[I]);
    Node := FileList.Items.AddChild(LNode,
              ExtractFileName(Files.Strings[I]));
    Node.ImageIndex := GetImgIndex(Files.Strings[I]);
    Node.SelectedIndex := Node.ImageIndex;
    Last := ExtractFilePath(Files.Strings[I]);
  end;

  if Expanded then
    for I:= 0 to Pred(FileList.Items.Count) do
      if FileList.Items.Item[I].Level = 0 then
        FileList.Items.Item[I].Expand(True);
end;

function TFrmPkgMan.PackageInstalled(const Name, Version: string): Boolean;
var
  I: Integer;
begin
  for I := 0 to PkgList.Items.Count - 1 do
  begin
    if (CompareText(TPkgItem(PkgList.Items.Item[I].Data).Name, Name) = 0) and
      (CompareText(TPkgItem(PkgList.Items.Item[I].Data).Version, Version) = 0) then
    begin
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

procedure TFrmPkgMan.LoadPackages;
var
  Item: TListItem;
  Files: TStrings;
  PkgInfo: TPkgItem;
  PkgDir: String;
  I: Integer;
  ini: TMemIniFile;
begin
  Files := TStringList.Create;
  PkgDir := GetFalconDir + 'Packages\';
  FindFiles(PkgDir + '*.ini', Files);
  for I := 0 to Pred(Files.Count) do
  begin
    ini := TMemIniFile.Create(PkgDir + Files.Strings[I]);
    PkgInfo := TPkgItem.Create;
    ini.ReadSectionValues('Files', PkgInfo.Files);
    PkgInfo.Name := ini.ReadString('Package', 'Name', '');
    PkgInfo.Version := ini.ReadString('Package', 'Version', '');
    PkgInfo.Description := ini.ReadString('Package', 'Description', '');
    PkgInfo.WebSiteCaption := ini.ReadString('Package', 'WebSiteCaption', '');
    PkgInfo.WebSite := ini.ReadString('Package', 'WebSite', '');
    PkgInfo.Dependencies := ini.ReadString('Package', 'Dependencies', '');
    Item := PkgList.Items.Add;
    Item.Caption := PkgInfo.Name;
    Item.Data := PkgInfo;
    Item.ImageIndex := 0;
    ini.Free;
  end;
end;

procedure TFrmPkgMan.ReloadPackages(var Message: TMessage);
begin
  PkgList.Clear;
  FileList.Items.Clear;
  LoadPackages;
end;

procedure TFrmPkgMan.FormCreate(Sender: TObject);
begin
  PkgListWndProc := PkgList.WindowProc;
  PkgList.WindowProc := PkgListProc;
  DragAcceptFiles(PkgList.Handle, True);

  PageControl.DoubleBuffered := True;
  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
  ConvertTo32BitImageList(ImgListToolbar);
  ConvertTo32BitImageList(HotImgListToolbar);
  ConvertTo32BitImageList(ImgPkgList);
  ConvertTo32BitImageList(ImgListMenu);

  addimages(ImgListToolbar, 'NORIMG');
  addimages(HotImgListToolbar, 'HOTIMG');
  addimages(ImgPkgList, 'PKGIMG');

  LoadPackages;
end;

procedure TFrmPkgMan.PkgListProc(var Msg: TMessage);
var
   FileCount : longInt;
   buffer : array[0..MAX_PATH] of char;
   S: String;
begin
  if Msg.Msg = WM_DROPFILES then
  begin
    FileCount := DragQueryFile(TWMDropFiles(Msg).Drop, $FFFFFFFF, nil, 0) ;
    if FileCount = 1 then
    begin
      DragQueryFile(TWMDropFiles(Msg).Drop, 0, @buffer, sizeof(buffer));
      S := StrPas(buffer);
      if LoadPackageFile(S) then
      begin
        FrmWizard := TFrmWizard.Create(Self);
        FraFnsh.ChbShow.Checked := False;
        FraFnsh.ChbShow.Enabled := False;
        FrmWizard.ShowModal;
        FrmWizard.Free;
        PkgList.Clear;
        FileList.Items.Clear;
        LoadPackages;
      end;
    end;
  end
  else
    PkgListWndProc(Msg);
end;

procedure TFrmPkgMan.TsInfoResize(Sender: TObject);
begin
  EdName.Width := TsInfo.Width - 20;
  EdVer.Width := TsInfo.Width - 20;
end;

procedure TFrmPkgMan.InstallClick(Sender: TObject);
begin
  {with TOpenDialog.Create(Self) do
  begin
    Filter :=
    'All package files(*.fpk, *.DevPak, *.zip)|*.fpk; *.DevPak; *.zip|' +
    'Falcon C++ package file(*.fpk)|*.fpk|' +
    'DevC++ package file(*.DevPak)|*.DevPak|' +
    'Zip file(*.zip)|*.zip|' +
    'All files|*.*';
    if Execute then
    begin
      if LoadPackageFile(FileName) then
      begin
        FrmWizard := TFrmWizard.Create(Self);
        FraFnsh.ChbShow.Checked := False;
        FraFnsh.ChbShow.Enabled := False;
        FrmWizard.ShowModal;
        FrmWizard.Free;
        PkgList.Clear;
        FileList.Items.Clear;
        LoadPackages;
      end;
      Free;
    end;
  end;}
  InstallPackages(Handle);
end;

procedure TFrmPkgMan.ExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmPkgMan.ViewControlsClick(Sender: TObject);
begin
  case TControl(Sender).Tag of
    0: ToolBar.Visible := TMenuItem(Sender).Checked;
    1: InfoPanel.Visible := TMenuItem(Sender).Checked;
    2: StatusBar.Visible := TMenuItem(Sender).Checked;
  end;
end;

procedure TFrmPkgMan.ReloadClick(Sender: TObject);
begin
  PkgList.Clear;
  FileList.Items.Clear;
  LoadPackages;
end;

procedure TFrmPkgMan.PkgListSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  PkgInfo: TPkgItem;
begin
  Splitter1.Visible := Selected;
  InfoPanel.Visible := Selected;
  TbUninstall.Enabled := Selected;
  Uninstall1.Enabled := Selected;
  TbCheck.Enabled := Selected;
  Check1.Enabled := Selected;
  FileList.Items.Clear;
  if Selected then
  begin
    PkgInfo := TPkgItem(Item.Data);
    EdName.Text := PkgInfo.Name;
    EdVer.Text := PkgInfo.Version;
    if Length(PkgInfo.WebSiteCaption) = 0 then
      LblSite.Caption := PkgInfo.WebSite
    else
      LblSite.Caption := PkgInfo.WebSiteCaption;
    LblSite.Hint := PkgInfo.WebSite;
    TextDesc.Text := PkgInfo.Description;
    CreateTree(PkgInfo.Files);
  end
  else
  begin
    EdName.Clear;
    EdVer.Clear;
    LblSite.Caption := '';
    TextDesc.Clear;
  end;
end;

procedure TFrmPkgMan.PkgListDeletion(Sender: TObject; Item: TListItem);
begin
  TPkgItem(Item.Data).Free;
end;

procedure TFrmPkgMan.LblSiteClick(Sender: TObject);
begin
  if PkgList.SelCount > 0 then
    Execute(TPkgItem(PkgList.Selected.Data).WebSite);
end;

procedure TFrmPkgMan.TbCheckClick(Sender: TObject);
var
  PkgInfo: TPkgItem;
  Forgot, I: Integer;
begin
  if PkgList.SelCount > 0 then
  begin
    Forgot := 0;
    PkgInfo := TPkgItem(PkgList.Selected.Data);
    for I:= 0 to Pred(PkgInfo.Files.Count) do
      if not FileExists(GetFalconDir + PkgInfo.Files.Strings[I]) then
        Inc(Forgot);
    if Forgot > 0 then
      MessageBox(Handle, PChar(Format('%d of %d Files not Found',
        [Forgot, PkgInfo.Files.Count])), PChar(Caption), MB_ICONWARNING)
    else
      MessageBox(Handle, 'Intact package files!',
        PChar(Caption), MB_ICONINFORMATION)
  end
end;

procedure TFrmPkgMan.PkgListMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  Item: TListItem;
begin
  Item := PkgList.GetItemAt(X, Y);
  if Assigned(Item) then
  begin
    PkgList.ShowHint := True;
    PkgList.Hint := TPkgItem(Item.Data).Name + ' ' + TPkgItem(Item.Data).Version;
  end
  else
    PkgList.ShowHint := False;
end;

procedure TFrmPkgMan.TbUninstallClick(Sender: TObject);
var
  Item: TPkgItem;
begin
  if PkgList.SelCount = 0 then Exit;
  Item := TPkgItem(PkgList.Selected.Data);
  MessageBeep(48);
  if MessageBox(Handle, PChar('Remove "' + Item.Name + '" - Version: ' +
    Item.Version + ' ?'), 'Falcon C++ Package Manager', MB_ICONQUESTION+
    MB_YESNOCANCEL) <> IDYES then Exit;
  UninstallPackage(Item.Name, Handle);
end;

procedure TFrmPkgMan.TbHelpClick(Sender: TObject);
begin
  FrmHelp := TFrmHelp.CreateParented(Handle);
  FrmHelp.ShowModal;
end;

function TFrmPkgMan.GetPathFromNode(Node: TTreeNode): string;
var
  Parent: TTreeNode;
begin
  Parent := Node;
  Result := '';
  while Parent <> nil do
  begin
    Result := '\' + Parent.Text + Result;
    Parent := Parent.Parent;
  end;
  if Pos(':', Result) > 0 then
    Exit;
  Result := ExcludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName))
    + Result;
end;

procedure TFrmPkgMan.CopyFileName1Click(Sender: TObject);
begin
  Clipboard.AsText := GetPathFromNode(FileList.Selected);
end;

procedure TFrmPkgMan.FileListChange(Sender: TObject; Node: TTreeNode);
begin
  CopyFileName1.Enabled := Node <> nil;
  OpenFolder1.Enabled := Node <> nil;
end;

procedure TFrmPkgMan.OpenFolder1Click(Sender: TObject);
var
  FileName: string;
begin
  FileName := GetPathFromNode(FileList.Selected);
  if not FileExists(FileName) and DirectoryExists(FileName) then
  begin
    if DirectoryExists(FileName) then
      ShellExecute(0, 'open', PChar(FileName), nil, nil, SW_SHOW);
  end
  else if FileExists(FileName) then
  begin
    if FileExists(FileName) then
      ShellExecute(0, 'open', 'explorer.exe',
        PChar('/select, "' + FileName + '"'), nil, SW_SHOW);
    //Edit;
  end;
end;

end.
