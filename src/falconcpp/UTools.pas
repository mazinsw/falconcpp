unit UTools;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, StdCtrls, ComCtrls, Mask, ImgList, Grids,
  ListGridView, ExtDlgs, UFileProperty, SynMemo, TBX, SynEditTypes,
  SynEditTextBuffer;

type
  TToolMenuItem = class(TTBXItem)
  private
    FStrCommand: String;
    FEnableCmd: String;
    FToolsID: Integer;
  public
    function ExecuteCommand: Boolean;
  published
    property StrCommand: String read FStrCommand write FStrCommand;
    property EnableCommand: String read FEnableCmd write FEnableCmd;
    property ToolID: Integer read FToolsID write FToolsID;
  end;

const
  NEW_LN = #13 + #10;

function GetIdent(Column: Integer):string;
procedure CreateStdTools;
function CreateRootMenuTool(Caption: String;
  RootMenu:TTBXSubmenuItem = nil): TTBXSubmenuItem;
function CreateMenuTool(RootMenu: TTBXSubmenuItem; Caption, StrCmd,
  EnableCmd: String): TToolMenuItem;

implementation

uses UFrmMain, SynEdit, UUtils;

function GetIdent(Column: Integer):string;
begin
  Result := '';
  while (Column > 0) do
  begin
    Dec(Column);
    Result := Result + ' ';
  end;
end;

function CreateRootMenuTool(Caption: String;
  RootMenu:TTBXSubmenuItem = nil): TTBXSubmenuItem;
var
  RtMenu: TTBXSubmenuItem;
begin
  RtMenu := TTBXSubmenuItem.Create(FrmFalconMain.PopEditorTools.Owner);
  RtMenu.Caption := Caption;
  if Assigned(RootMenu) then
    RootMenu.Add(RtMenu);
  FrmFalconMain.PopEditorTools.Add(RtMenu);
  Result := RtMenu;
end;

function CreateMenuTool(RootMenu: TTBXSubmenuItem; Caption,
  StrCmd, EnableCmd: String): TToolMenuItem;
var
  MTools: TToolMenuItem;
begin
  MTools := TToolMenuItem.Create(FrmFalconMain.PopEditorTools.Owner);
  MTools.Caption := Caption;
  MTools.StrCommand := StrCmd;
  MTools.EnableCommand := EnableCmd;
  MTools.OnClick := FrmFalconMain.ToolsClick;
  RootMenu.Add(MTools);
  Result := MTools;
end;

procedure CreateStdTools;
var
  RMenuTool: TTBXSubmenuItem;
  ItemTool: TToolMenuItem;
begin
  RMenuTool := CreateRootMenuTool('Convertions');
  CreateMenuTool(RMenuTool,
    'Selection to Hex', 'STD:TOHEX', 'STD:SELTEXT').ToolID := 0;
  CreateMenuTool(RMenuTool,
    'Selection to Int', 'STD:TOINT', 'STD:SELTEXT').ToolID := 2;
  ItemTool := CreateMenuTool(RMenuTool,
    'Resolve special chars', 'STD:TORES', 'STD:SELTEXT');
  ItemTool.ToolID := 4;
  ItemTool.ShortCut := ShortCut(Ord('R'), [ssCtrl, ssAlt]);

  RMenuTool := CreateRootMenuTool('Samples');
  CreateMenuTool(RMenuTool,
    'Insert datetime', 'STD:INSDT', '').ToolID := 5;
  ItemTool := CreateMenuTool(RMenuTool,
    'Insert definition header', 'STD:INSDHD', '');
  ItemTool.ToolID := 9;
  ItemTool.ShortCut := ShortCut(Ord('H'), [ssCtrl, ssAlt]);
  RMenuTool := CreateRootMenuTool('Advanced');
  CreateMenuTool(RMenuTool,
    'Implement class functions...', 'STD:IMPCFC', 'STD:FILEH').ToolID := 11;
  CreateMenuTool(RMenuTool,
    'Implement window controls...', 'STD:IMPWCT', 'STD:FILEC').ToolID := 12;
end;

function TToolMenuItem.ExecuteCommand: Boolean;
const
  SCHAR = 'ƒ¶…· µÆÇˆÒŠÔ‚Œ×Þ¡Öäå“â•ã¢àš–ê£é—ë‡€¤¥¦§øûýü©¸ñö«¬ó';
  NCHAR = 'âÂàÀáÁãÃêÊèÈéÉîÎìÌíÍõÕôÔòÒóÓüÜûÛúÚùÙçÇñÑªº°¹²³®©±÷½¼¾';
var
  SelText, Temp, Ident: String;
  Memo: TSynMemo;
  Line, Column, I, J: Integer;
  FileProp: TFileProperty;
  //ProjProp: TProjectProperty;
  Sheet: TFilePropertySheet;
begin
  Result := True;
  Sheet := TFilePropertySheet(FrmFalconMain.PageControlEditor.ActivePage);
  FileProp := TFileProperty(Sheet.Node.Data);
  //ProjProp := FileProp.Project;
  Memo := Sheet.Memo;

  Line := Memo.DisplayY;
  Column := Memo.DisplayX;
  SelText := Memo.SelText;
  Ident := GetIdent(Column);

  case ToolID of
    0: if (Length(SelText) > 0) then
        Memo.SelText := '0x' + IntToHex(StrToIntDef(SelText, 0), 6);
    2: if (Length(SelText) > 0) then
        Memo.SelText := IntToStr(StrToIntDef(
          StringReplace(SelText, '0x', '$', []), 0));
    4:
    begin
      Temp := Memo.SelText;
      for I:=1 to Length(Temp) do
      begin
        for J:= 1 to Length(NCHAR) do
          if(Temp[I] = NCHAR[J])then
            Temp[I] := SCHAR[J];
      end;
      Memo.SelText := Temp;
    end;
    5: Memo.SelText := DateTimeToStr(Now);
    9:
    begin
      Temp := StringReplace(FileProp.Caption, '.', '_', [rfReplaceAll]);
      Temp := StringReplace(Temp, ' ', '_', [rfReplaceAll]);
      Temp := UpperCase(Temp);
      Memo.Text := '#ifndef _' + Temp + '_' + #13 + '#define _' + Temp + '_' +
        #13 + Memo.Text + #13 + '#endif';
      Memo.GotoLineAndCenter(Line + 2);
    end;
  else
    //exec user functions
  end;
end;

end.
 