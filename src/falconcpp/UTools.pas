unit UTools;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, USourceFile, SpTBXItem;

type
  TToolMenuItem = class(TSpTBXItem)
  private
    FStrCommand: string;
    FEnableCmd: string;
    FToolsID: Integer;
  public
    function ExecuteCommand: Boolean;
  published
    property StrCommand: string read FStrCommand write FStrCommand;
    property EnableCommand: string read FEnableCmd write FEnableCmd;
    property ToolID: Integer read FToolsID write FToolsID;
  end;

const
  NEW_LN = #13 + #10;

procedure CreateStdTools;
function CreateRootMenuTool(Caption: string; RootMenu: TSpTBXSubmenuItem = nil)
  : TSpTBXSubmenuItem;
function CreateMenuTool(RootMenu: TSpTBXSubmenuItem;
  Caption, StrCmd, EnableCmd: string): TToolMenuItem;

implementation

uses UFrmMain, UEditor;

function CreateRootMenuTool(Caption: string; RootMenu: TSpTBXSubmenuItem = nil)
  : TSpTBXSubmenuItem;
var
  RtMenu: TSpTBXSubmenuItem;
begin
  RtMenu := TSpTBXSubmenuItem.Create(FrmFalconMain.PopEditorTools.Owner);
  RtMenu.Caption := Caption;
  if Assigned(RootMenu) then
    RootMenu.Add(RtMenu);
  FrmFalconMain.PopEditorTools.Add(RtMenu);
  Result := RtMenu;
end;

function CreateMenuTool(RootMenu: TSpTBXSubmenuItem;
  Caption, StrCmd, EnableCmd: string): TToolMenuItem;
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
  RMenuTool: TSpTBXSubmenuItem;
  ItemTool: TToolMenuItem;
begin
  RMenuTool := CreateRootMenuTool('Convertions');
  CreateMenuTool(RMenuTool, 'Selection to Hex', 'STD:TOHEX', 'STD:SELTEXT')
    .ToolID := 0;
  CreateMenuTool(RMenuTool, 'Selection to Int', 'STD:TOINT', 'STD:SELTEXT')
    .ToolID := 2;
  ItemTool := CreateMenuTool(RMenuTool, 'Resolve special chars', 'STD:TORES',
    'STD:SELTEXT');
  ItemTool.ToolID := 4;
  ItemTool.ShortCut := ShortCut(Ord('R'), [ssCtrl, ssAlt]);

  RMenuTool := CreateRootMenuTool('Samples');
  CreateMenuTool(RMenuTool, 'Insert datetime', 'STD:INSDT', '').ToolID := 5;
  ItemTool := CreateMenuTool(RMenuTool, 'Insert definition header',
    'STD:INSDHD', '');
  ItemTool.ToolID := 9;
  ItemTool.ShortCut := ShortCut(Ord('H'), [ssCtrl, ssAlt]);
end;

function TToolMenuItem.ExecuteCommand: Boolean;
var
  SelText, Temp: string;
  AnsiTemp: AnsiString;
  Memo: TEditor;
  FileProp: TSourceFile;
  Sheet: TSourceFileSheet;
begin
  Result := True;
  Sheet := TSourceFileSheet(FrmFalconMain.PageControlEditor.ActivePage);
  FileProp := Sheet.SourceFile;
  Memo := Sheet.Editor;
  if Memo.readonly then
    Exit;
  case ToolID of
    0:
      if (Length(SelText) > 0) then
        Memo.SelText := '0x' + IntToHex(StrToIntDef(SelText, 0), 6);
    2:
      if (Length(SelText) > 0) then
        Memo.SelText := IntToStr(StrToIntDef(StringReplace(SelText, '0x', '$',
              []), 0));
    4:
      begin
        AnsiTemp := AnsiString(Memo.SelText);
        AnsiToOem(PAnsiChar(AnsiTemp), PAnsiChar(AnsiTemp));
        Memo.SelText := string(AnsiTemp);
      end;
    5:
      Memo.SelText := DateTimeToStr(Now);
    9:
      begin
        Temp := StringReplace(FileProp.name, '.', '_', [rfReplaceAll]);
        Temp := StringReplace(Temp, ' ', '_', [rfReplaceAll]);
        Temp := UpperCase(Temp);
        Memo.BeginUndoAction;
        Memo.SetEmptySelection(Memo.GetTextLength);
        Memo.SelText := Memo.GetLineChars + '#endif /* _' + Temp + '_ */';
        Memo.SetEmptySelection(0);
        Memo.SelText := '#ifndef _' + Temp + '_' + Memo.GetLineChars +
          '#define _' + Temp + '_' + Memo.GetLineChars;
        Memo.GotoLineAndCenter(3);
        Memo.EndUndoAction;
      end;
  else
    // exec user functions
  end;
end;

end.
