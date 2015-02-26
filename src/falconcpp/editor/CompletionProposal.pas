{ -------------------------------------------------------------------------------
  The contents of this file are subject to the Mozilla Public License
  Version 1.1 (the "License"); you may not use this file except in compliance
  with the License. You may obtain a copy of the License at
  http://www.mozilla.org/MPL/

  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
  the specific language governing rights and limitations under the License.

  The Original Code is: CompletionProposal.pas, released 2000-04-11.
  The Original Code is based on mwCompletionProposal.pas by Cyrille de Brebisson,
  part of the mwEdit component suite.
  Portions created by Cyrille de Brebisson are Copyright (C) 1999
  Cyrille de Brebisson. All Rights Reserved.

  Contributors to the SynEdit and mwEdit projects are listed in the
  Contributors.txt file.

  Alternatively, the contents of this file may be used under the terms of the
  GNU General Public License Version 2 or later (the "GPL"), in which case
  the provisions of the GPL are applicable instead of those above.
  If you wish to allow use of your version of this file only under the terms
  of the GPL and not to allow others to use your version of this file
  under the MPL, indicate your decision by deleting the provisions above and
  replace them with the notice and other provisions required by the GPL.
  If you do not delete the provisions above, a recipient may use your version
  of this file under either the MPL or the GPL.

  $Id: CompletionProposal.pas,v 1.76 2006/01/25 13:16:23 etrusco Exp $

  You may retrieve the latest version of this file at the SynEdit home page,
  located at http://SynEdit.SourceForge.net

  Known Issues:
  ------------------------------------------------------------------------------- }

unit CompletionProposal;

interface

uses
  Windows,
  UxTheme,
  Messages,
  Graphics,
  Forms,
  Controls,
  StdCtrls,
  ExtCtrls,
  Menus,
  Dialogs,
  UEditor,
  SysUtils,
  Classes,
  DScintillaTypes;

const
  TSynSpecialChars = ['À' .. 'Ö', 'Ø' .. 'ö', 'ø' .. 'ÿ'];
  TSynValidStringChars = ['_', '0' .. '9', 'A' .. 'Z',
    'a' .. 'z'] + TSynSpecialChars;
  TSynWordBreakChars = ['.', ',', ';', ':', '"', '''', '!', '?', '[', ']', '(',
    ')', '{', '}', '^', '-', '=', '+', '-', '*', '/', '\', '|'];

type
  TSynIdentChars = set of AnsiChar;
  TSynCompletionType = (ctCode, ctHint, ctParams);
  SynCompletionType = TSynCompletionType; // Keep an alias to old name for now.

  TSynForm = TCustomForm;

  TSynBaseCompletionProposalPaintItem = procedure(Sender: TObject;
    index: Integer; TargetCanvas: TCanvas; ItemRect: TRect;
    var CustomDraw: Boolean) of object;

  TSynBaseCompletionProposalMeasureItem = procedure(Sender: TObject;
    index: Integer; TargetCanvas: TCanvas; var ItemWidth: Integer) of object;

  TCodeCompletionEvent = procedure(Sender: TObject; var Value: string;
    Shift: TShiftState; index: Integer; var EndToken: Char;
    var OffsetCaret: Integer) of object;

  // ##Falcon C++ Changes
  TGetWordBreakCharsEvent = procedure(Sender: TObject; var WordBreakChars,
    ScanBreakChars: string) of object;
  TGetWordEndCharsEvent = procedure(Sender: TObject; var WordEndChars: string;
    index: Integer; var Handled: Boolean) of object;
  // ##End Falcon C++ Changes

  // GBN 14/11/2001
  TAfterCodeCompletionEvent = procedure(Sender: TObject; const Value: string;
    Shift: TShiftState; index: Integer; var EndToken: Char) of object;

  TValidateEvent = procedure(Sender: TObject; Shift: TShiftState;
    var EndToken: Char) of object; // GBN15/11/2001, Added EndToken

  TCompletionParameter = procedure(Sender: TObject; CurrentIndex: Integer;
    var Level, IndexToDisplay: Integer; var Key: Char;
    var DisplayString: string) of object;

  TCompletionExecute = procedure(Kind: SynCompletionType; Sender: TObject;
    var CurrentInput: string; var x, y: Integer;
    var CanExecute: Boolean) of object;

  TCompletionChange = procedure(Sender: TObject; AIndex: Integer) of object;

  TSynCompletionOption = (scoAnsiStrings, // Use Ansi comparison during string operations
    scoCaseSensitive, // Use case sensitivity to do matches
    scoLimitToMatchedText, // Limit the matched text to only what they have typed in
    scoTitleIsCentered, // Center the title in the box if you choose to use titles
    scoUseInsertList, // Use the InsertList to insert text instead of the ItemList (which will be displayed)
    scoUsePrettyText, // Use the PrettyText function to output the words
    scoUseBuiltInTimer, // Use the built in timer and the trigger keys to execute the proposal as well as the shortcut
    scoEndCharCompletion, // When an end char is pressed, it triggers completion to occur (like the Delphi IDE)
    scoConsiderWordBreakChars, // Use word break characters as additional end characters
    scoCompleteWithTab, // Use the tab character for completion
    scoCompleteWithEnter); // Use the Enter character for completion

  TSynCompletionOptions = set of TSynCompletionOption;

const
  DefaultProposalOptions = [scoLimitToMatchedText, scoEndCharCompletion,
    scoCompleteWithTab, scoCompleteWithEnter];
  DefaultEndOfTokenChr = '()[]. ';
  DefaulTSynIdentChars = ['0' .. '9', 'a' .. 'z', 'A' .. 'Z', '_'];

type
  TProposalColumns = class;

  TSynBaseCompletionProposalForm = class(TSynForm)
  private
    FCurrentString: string;
    FOnKeyPress: TKeyPressEvent;
    FOnPaintItem: TSynBaseCompletionProposalPaintItem;
    FOnMeasureItem: TSynBaseCompletionProposalMeasureItem;
    FOnChangePosition: TCompletionChange;
    FItemList: TStrings;
    FInsertList: TStrings;
    FAssignedList: TStrings;
    FPosition: Integer;
    FLinesInWindow: Integer;
    FTitleFontHeight: Integer;
    FFontHeight: Integer;
    FScrollbar: TScrollBar;
    FOnValidate: TValidateEvent;
    FOnCancel: TNotifyEvent;
    FClSelect: TColor;
    fClSelectText: TColor;
    FClTitleBackground: TColor;
    fClBackGround: TColor;
    FWordBreakChars: TSynIdentChars;
    FScanChars: TSynIdentChars;
    Bitmap: TBitmap; // used for drawing
    TitleBitmap: TBitmap; // used for title-drawing
    FCurrentEditor: TEditor;
    FTitle: string;
    FTitleFont: TFont;
    FFont: TFont;
    FResizeable: Boolean;
    FItemHeight: Integer;
    FMargin: Integer;
    FEffectiveItemHeight: Integer;
    FImages: TImageList;
    FMouseOverIndex: Integer;

    // These are the reflections of the Options property of the CompletionProposal
    FAnsi: Boolean;
    FCase: Boolean;
    FMatchText: Boolean;
    FFormattedText: Boolean;
    FCenterTitle: Boolean;
    FUseInsertList: Boolean;
    FCompleteWithTab: Boolean;
    FCompleteWithEnter: Boolean;

    FMouseWheelAccumulator: Integer;
    FDisplayKind: SynCompletionType;
    FParameterToken: TCompletionParameter;
    FCurrentIndex: Integer;
    FCurrentLevel: Integer;
    FDefaultKind: SynCompletionType;
    FEndOfTokenChr: string;
    FTriggerChars: string;
    FHeightBuffer: Integer;
    FColumns: TProposalColumns;
    procedure SetCurrentString(const Value: string);
    procedure MoveLine(cnt: Integer);
    procedure ScrollbarOnChange(Sender: TObject);
    procedure ScrollbarOnScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure ScrollbarOnEnter(Sender: TObject);

    procedure SetItemList(const Value: TStrings);
    procedure SetInsertList(const Value: TStrings);
    procedure SetPosition(const Value: Integer);
    procedure SetResizeable(const Value: Boolean);
    procedure SetItemHeight(const Value: Integer);
    procedure SetImages(const Value: TImageList);
    procedure StringListChange(Sender: TObject);
    procedure DoDoubleClick(Sender: TObject);
    procedure DoFormShow(Sender: TObject);
    procedure DoFormHide(Sender: TObject);
    procedure AdjustScrollBarPosition;
    procedure AdjustMetrics;
    procedure SetTitle(const Value: string);
    procedure SetFont(const Value: TFont);
    procedure SetTitleFont(const Value: TFont);
    procedure SetColumns(Value: TProposalColumns);
    procedure TitleFontChange(Sender: TObject);
    procedure FontChange(Sender: TObject);
    procedure RecalcItemHeight;
    function ItemIndexAt(const P: TPoint): Integer;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Paint; override;
    procedure Activate; override;
    procedure Deactivate; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      x, y: Integer); override;
    procedure Resize; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
    procedure WMMouseWheel(var Msg: TMessage); message WM_MOUSEWHEEL;
    procedure WMEraseBackgrnd(var message: TMessage); message WM_ERASEBKGND;
    procedure WMGetDlgCode(var message: TWMGetDlgCode); message WM_GETDLGCODE;
    // GBN 24/02/2002
    procedure WMMouseMove(var message: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMNCMouseMove(var message: TWMNCMouseMove);
      message WM_NCMOUSEMOVE;
    procedure CMMouseLeave(var message: TMessage); message CM_MOUSELEAVE;
    procedure CreateParams(var Params: TCreateParams); override;

    function CanResize(var NewWidth, NewHeight: Integer): Boolean; override;
    procedure HandleMouseMove(Shift: TShiftState; x: Integer; y: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function LogicalToPhysicalIndex(index: Integer): Integer;
    function PhysicalToLogicalIndex(index: Integer): Integer;

    property DisplayType
      : SynCompletionType read FDisplayKind write FDisplayKind;
    property DefaultType
      : SynCompletionType read FDefaultKind write FDefaultKind
      default ctCode;
    property CurrentString: string read FCurrentString write SetCurrentString;
    property CurrentIndex: Integer read FCurrentIndex write FCurrentIndex;
    property CurrentLevel: Integer read FCurrentLevel write FCurrentLevel;
    property OnParameterToken
      : TCompletionParameter read FParameterToken write FParameterToken;
    property OnKeyPress: TKeyPressEvent read FOnKeyPress write FOnKeyPress;
    property OnPaintItem
      : TSynBaseCompletionProposalPaintItem read FOnPaintItem write
      FOnPaintItem;
    property OnMeasureItem
      : TSynBaseCompletionProposalMeasureItem read FOnMeasureItem write
      FOnMeasureItem;
    property OnValidate: TValidateEvent read FOnValidate write FOnValidate;
    property OnCancel: TNotifyEvent read FOnCancel write FOnCancel;
    property ItemList: TStrings read FItemList write SetItemList;
    property InsertList: TStrings read FInsertList write SetInsertList;
    property AssignedList: TStrings read FAssignedList write FAssignedList;
    property Position: Integer read FPosition write SetPosition;
    property Title: string read FTitle write SetTitle;
    property ClSelect
      : TColor read FClSelect write FClSelect default clHighlight;
    property ClSelectedText
      : TColor read fClSelectText write fClSelectText default
      clHighlightText;
    property ClBackground
      : TColor read fClBackGround write fClBackGround default clWindow;
    property ClTitleBackground
      : TColor read FClTitleBackground write FClTitleBackground default
      clBtnFace;
    property ItemHeight: Integer read FItemHeight write SetItemHeight default 0;
    property Margin: Integer read FMargin write FMargin default 2;

    property UsePrettyText
      : Boolean read FFormattedText write FFormattedText default
      False;
    property UseInsertList
      : Boolean read FUseInsertList write FUseInsertList default
      False;
    property CenterTitle
      : Boolean read FCenterTitle write FCenterTitle default True;
    property AnsiStrings: Boolean read FAnsi write FAnsi default True;
    property CaseSensitive: Boolean read FCase write FCase default False;
    property CurrentEditor: TEditor read FCurrentEditor write FCurrentEditor;
    property MatchText: Boolean read FMatchText write FMatchText;
    property EndOfTokenChr: string read FEndOfTokenChr write FEndOfTokenChr;
    property TriggerChars: string read FTriggerChars write FTriggerChars;
    property CompleteWithTab
      : Boolean read FCompleteWithTab write FCompleteWithTab;
    property CompleteWithEnter
      : Boolean read FCompleteWithEnter write FCompleteWithEnter;

    property TitleFont: TFont read FTitleFont write SetTitleFont;
    property Font: TFont read FFont write SetFont;
    property Columns: TProposalColumns read FColumns write SetColumns;
    property Resizeable
      : Boolean read FResizeable write SetResizeable default True;
    property Images: TImageList read FImages write SetImages;
  end;

  TSynBaseCompletionProposal = class(TComponent)
  private
    FForm: TSynBaseCompletionProposalForm;
    FOnExecute: TCompletionExecute;
    FOnClose: TNotifyEvent; // GBN 28/08/2002
    FOnShow: TNotifyEvent; // GBN 28/08/2002
    FWidth: Integer;
    FPreviousToken: string;
    FDotOffset: Integer;
    FOptions: TSynCompletionOptions;
    FNbLinesInWindow: Integer;

    FCanExecute: Boolean;
    function GetClSelect: TColor;
    procedure SetClSelect(const Value: TColor);
    function GetCurrentString: string;
    function GetItemList: TStrings;
    function GetInsertList: TStrings;
    function GetOnCancel: TNotifyEvent;
    function GetOnKeyPress: TKeyPressEvent;
    function GetOnPaintItem: TSynBaseCompletionProposalPaintItem;
    function GetOnMeasureItem: TSynBaseCompletionProposalMeasureItem;
    function GetOnValidate: TValidateEvent;
    function GetPosition: Integer;
    procedure SetCurrentString(const Value: string);
    procedure SetItemList(const Value: TStrings);
    procedure SetInsertList(const Value: TStrings);
    procedure SetNbLinesInWindow(const Value: Integer);
    procedure SetOnCancel(const Value: TNotifyEvent);
    procedure SetOnKeyPress(const Value: TKeyPressEvent);
    procedure SetOnPaintItem(const Value: TSynBaseCompletionProposalPaintItem);
    procedure SetOnMeasureItem(const Value:
        TSynBaseCompletionProposalMeasureItem);
    procedure SetPosition(const Value: Integer);
    procedure SetOnValidate(const Value: TValidateEvent);
    procedure SetWidth(Value: Integer);
    procedure SetImages(const Value: TImageList);
    function GetDisplayKind: SynCompletionType;
    procedure SetDisplayKind(const Value: SynCompletionType);
    function GetParameterToken: TCompletionParameter;
    procedure SetParameterToken(const Value: TCompletionParameter);
    function GetDefaultKind: SynCompletionType;
    procedure SetDefaultKind(const Value: SynCompletionType);
    function GetClBack: TColor;
    procedure SetClBack(const Value: TColor);
    function GetClSelectedText: TColor;
    procedure SetClSelectedText(const Value: TColor);
    function GetEndOfTokenChar: string;
    procedure SetEndOfTokenChar(const Value: string);
    function GetClTitleBackground: TColor;
    procedure SetClTitleBackground(const Value: TColor);
    procedure SetTitle(const Value: string);
    function GetTitle: string;
    function GetFont: TFont;
    function GetTitleFont: TFont;
    procedure SetFont(const Value: TFont);
    procedure SetTitleFont(const Value: TFont);
    function GetOptions: TSynCompletionOptions;
    function GetTriggerChars: string;
    procedure SetTriggerChars(const Value: string);
    function GetOnChange: TCompletionChange;
    procedure SetOnChange(const Value: TCompletionChange);
    procedure SetColumns(const Value: TProposalColumns);
    function GetColumns: TProposalColumns;
    function GetResizeable: Boolean;
    procedure SetResizeable(const Value: Boolean);
    function GetItemHeight: Integer;
    procedure SetItemHeight(const Value: Integer);
    function GetMargin: Integer;
    procedure SetMargin(const Value: Integer);
    function GetImages: TImageList;
  protected
    procedure SetOptions(const Value: TSynCompletionOptions); virtual;
    procedure EditorCancelMode(Sender: TObject); virtual; // GBN 13/11/2001
  public
    constructor Create(AOwner: TComponent); override;
    procedure Execute(s: string; x, y: Integer);
    procedure ExecuteEx(s: string; x, y: Integer;
      Kind: SynCompletionType = ctCode); virtual;
    procedure Activate;
    procedure Deactivate;

    procedure ClearList;
    function DisplayItem(AIndex: Integer): string;
    function InsertItem(AIndex: Integer): string;
    procedure AddItemAt(Where: Integer; ADisplayText, AInsertText: string);
    procedure AddItem(ADisplayText, AInsertText: string);
    procedure ResetAssignedList;

    property OnKeyPress: TKeyPressEvent read GetOnKeyPress write SetOnKeyPress;
    property OnValidate: TValidateEvent read GetOnValidate write SetOnValidate;
    property OnCancel: TNotifyEvent read GetOnCancel write SetOnCancel;
    property CurrentString: string read GetCurrentString write SetCurrentString;
    property DotOffset: Integer read FDotOffset write FDotOffset;
    property DisplayType: SynCompletionType read GetDisplayKind write
      SetDisplayKind;
    property Form: TSynBaseCompletionProposalForm read FForm;
    property PreviousToken: string read FPreviousToken;
    property Position: Integer read GetPosition write SetPosition;
  published
    property DefaultType: SynCompletionType read GetDefaultKind write
      SetDefaultKind default ctCode;
    property Options
      : TSynCompletionOptions read GetOptions write SetOptions
      default DefaultProposalOptions;

    property ItemList: TStrings read GetItemList write SetItemList;
    property InsertList: TStrings read GetInsertList write SetInsertList;
    property NbLinesInWindow: Integer read FNbLinesInWindow write
      SetNbLinesInWindow default 8;
    property ClSelect: TColor read GetClSelect write SetClSelect default
      clHighlight;
    property ClSelectedText
      : TColor read GetClSelectedText write SetClSelectedText default
      clHighlightText;
    property ClBackground
      : TColor read GetClBack write SetClBack default clWindow;
    property ClTitleBackground: TColor read GetClTitleBackground write
      SetClTitleBackground default clBtnFace;
    property Width: Integer read FWidth write SetWidth default 260;
    property EndOfTokenChr: string read GetEndOfTokenChar write
      SetEndOfTokenChar;
    property TriggerChars: string read GetTriggerChars write SetTriggerChars;
    property Title: string read GetTitle write SetTitle;
    property Font: TFont read GetFont write SetFont;
    property TitleFont: TFont read GetTitleFont write SetTitleFont;
    property Columns: TProposalColumns read GetColumns write SetColumns;
    property Resizeable
      : Boolean read GetResizeable write SetResizeable default True;
    property ItemHeight
      : Integer read GetItemHeight write SetItemHeight default 0;
    property Images: TImageList read GetImages write SetImages default nil;
    property Margin: Integer read GetMargin write SetMargin default 2;

    property OnChange: TCompletionChange read GetOnChange write SetOnChange;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    // GBN 28/08/2002
    property OnExecute: TCompletionExecute read FOnExecute write FOnExecute;
    property OnMeasureItem: TSynBaseCompletionProposalMeasureItem read
      GetOnMeasureItem write SetOnMeasureItem;
    property OnPaintItem: TSynBaseCompletionProposalPaintItem read
      GetOnPaintItem write SetOnPaintItem;
    property OnParameterToken
      : TCompletionParameter read GetParameterToken write
      SetParameterToken;
    property OnShow: TNotifyEvent read FOnShow write FOnShow; // GBN 28/08/2002
  end;

  TCompletionProposal = class(TSynBaseCompletionProposal)
  private
    FShortCut: TShortCut;
    FCompletionStart: Integer;
    FAdjustCompletionStart: Boolean;
    FOnCodeCompletion: TCodeCompletionEvent;
    // ##Falcon C++ Changes
    FOnGetWordBreakChars: TGetWordBreakCharsEvent;
    FOnGetWordEndChars: TGetWordEndCharsEvent;
    // ##End Falcon C++ Changes
    FTimer: TTimer;
    FTimerInterval: Integer;
    FOnAfterCodeCompletion: TAfterCodeCompletionEvent; // GBN 18/11/2001
    FOnCancelled: TNotifyEvent; // GBN 13/11/2001
    procedure HandleOnCancel(Sender: TObject);
    procedure HandleOnValidate(Sender: TObject; Shift: TShiftState;
      var EndToken: Char);
    procedure HandleOnKeyPress(Sender: TObject; var Key: Char);
    procedure HandleDblClick(Sender: TObject);
    procedure TimerExecute(Sender: TObject);
    function GetPreviousToken(AEditor: TEditor): string;
    function GetCurrentInput(AEditor: TEditor): string;
    function GetTimerInterval: Integer;
    procedure SetTimerInterval(const Value: Integer);
    procedure InternalCancelCompletion;
    function GetExecuting: Boolean; // GBN 25/02/2002
  protected
    procedure DoExecute(AEditor: TEditor); virtual;
    procedure SetShortCut(Value: TShortCut);
    procedure SetOptions(const Value: TSynCompletionOptions); override;
    procedure EditorCancelMode(Sender: TObject); override; // GBN 13/11/2001
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ExecuteEx(s: string; x, y: Integer;
      Kind: SynCompletionType = ctCode); override;
    procedure ActivateCompletion(Editor: TEditor); // GBN 13/11/2001
    procedure CancelCompletion; // GBN 11/11/2001
    property Executing: Boolean read GetExecuting;
    procedure ActivateTimer(ACurrentEditor: TEditor);
    procedure DeactivateTimer;
    property CompletionStart
      : Integer read FCompletionStart write FCompletionStart;
    // ET 04/02/2003
    procedure EditorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditorKeyPress(Sender: TObject; var Key: Char);
  published
    property ShortCut: TShortCut read FShortCut write SetShortCut;
    property TimerInterval
      : Integer read GetTimerInterval write SetTimerInterval
      default 1000;

    property OnAfterCodeCompletion
      : TAfterCodeCompletionEvent read FOnAfterCodeCompletion write
      FOnAfterCodeCompletion;
    property OnCancelled: TNotifyEvent read FOnCancelled write FOnCancelled;
    property OnCodeCompletion
      : TCodeCompletionEvent read FOnCodeCompletion write
      FOnCodeCompletion;
    // ##Falcon C++ Changes
    property OnGetWordBreakChars
      : TGetWordBreakCharsEvent read FOnGetWordBreakChars write
      FOnGetWordBreakChars;
    property OnGetWordEndChars
      : TGetWordEndCharsEvent read FOnGetWordEndChars write
      FOnGetWordEndChars;
    // ##End Falcon C++ Changes
  end;

  TProposalColumn = class(TCollectionItem)
  private
    FBiggestWord: string;
    FInternalWidth: Integer;
    FFontStyle: TFontStyles;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property BiggestWord: string read FBiggestWord write FBiggestWord;
    property DefaultFontStyle
      : TFontStyles read FFontStyle write FFontStyle default[];
  end;

  TProposalColumns = class(TCollection)
  private
    FOwner: TPersistent;
    function GetItem(index: Integer): TProposalColumn;
    procedure SetItem(index: Integer; Value: TProposalColumn);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TPersistent; ItemClass: TCollectionItemClass);
    function Add: TProposalColumn;
    function FindItemID(ID: Integer): TProposalColumn;
    function Insert(index: Integer): TProposalColumn;
    property Items[index: Integer]: TProposalColumn read GetItem write SetItem;
    default;
  end;

procedure FormattedTextOut(TargetCanvas: TCanvas; const Rect: TRect;
  const Text: string; Selected: Boolean; Columns: TProposalColumns;
  Images: TImageList);
function FormattedTextWidth(TargetCanvas: TCanvas; const Text: string;
  Columns: TProposalColumns; Images: TImageList): Integer;
function PrettyTextToFormattedString(const APrettyText: string;
  AlternateBoldStyle: Boolean = False): string;

implementation

uses
  Math, DScintilla;

const
  TextHeightString = 'CompletionProposal';

  // ------------------------- Formatted painting stuff ---------------------------

type
  TFormatCommand = (fcNoCommand, fcColor, fcStyle, fcColumn, fcHSpace, fcImage);
  TFormatCommands = set of TFormatCommand;

  PFormatChunk = ^TFormatChunk;

  TFormatChunk = record
    Str: string;
    Command: TFormatCommand;
    Data: Pointer;
  end;

  PFormatStyleData = ^TFormatStyleData;

  TFormatStyleData = record
    Style: Char;
    Action: Integer; // -1 = Reset, +1 = Set, 0 = Toggle
  end;

  TFormatChunkList = class
  private
    FChunks: TList;
    function GetCount: Integer;
    function GetChunk(index: Integer): PFormatChunk;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Add(AChunk: PFormatChunk);
    property Count: Integer read GetCount;
    property Chunks[index: Integer]: PFormatChunk read GetChunk; default;
  end;

const
  AllCommands = [fcColor .. high(TFormatCommand)];

function TFormatChunkList.GetCount: Integer;
begin
  Result := FChunks.Count;
end;

function TFormatChunkList.GetChunk(index: Integer): PFormatChunk;
begin
  Result := FChunks[index];
end;

procedure TFormatChunkList.Clear;
var
  C: PFormatChunk;
  StyleFormatData: PFormatStyleData;
begin
  while FChunks.Count > 0 do
  begin
    C := FChunks.Last;
    FChunks.Delete(FChunks.Count - 1);

    case C^.Command of
      fcStyle:
        begin
          StyleFormatData := C^.Data;
          Dispose(StyleFormatData);
        end;
    end;

    Dispose(C);
  end;
end;

constructor TFormatChunkList.Create;
begin
  inherited Create;
  FChunks := TList.Create;
end;

destructor TFormatChunkList.Destroy;
begin
  Clear;
  FChunks.Free;
  inherited Destroy;
end;

procedure TFormatChunkList.Add(AChunk: PFormatChunk);
begin
  FChunks.Add(AChunk);
end;

function ParseFormatChunks(const FormattedString: string;
  ChunkList: TFormatChunkList; const StripCommands: TFormatCommands): Boolean;
var
  CurChar: Char;
  CurPos: Integer;
  CurrentChunk: string;
  PossibleErrorPos: Integer;
  ErrorFound: Boolean;

  procedure NextChar;
  begin
    inc(CurPos);
{$IFOPT R+}
    // Work-around Delphi's annoying behaviour of failing the RangeCheck when
    // reading the final #0 char
    if CurPos = Length(FormattedString) + 1 then
      CurChar := #0
    else
{$ENDIF}
      CurChar := FormattedString[CurPos];
  end;

  procedure AddStringChunk;
  var
    C: PFormatChunk;
  begin
    C := New(PFormatChunk);
    C^.Str := CurrentChunk;
    C^.Command := fcNoCommand;
    C^.Data := nil;
    ChunkList.Add(C);

    CurrentChunk := '';
  end;

  procedure AddCommandChunk(ACommand: TFormatCommand; Data: Pointer);
  var
    C: PFormatChunk;
  begin
    C := New(PFormatChunk);
    C^.Str := '';
    C^.Command := ACommand;
    C^.Data := Data;
    ChunkList.Add(C);
  end;

  procedure ParseEscapeSequence;
  var
    Command: string;
    Parameter: string;
    CommandType: TFormatCommand;
    Data: Pointer;
  begin
    Assert(CurChar = '\');
    NextChar;
    if CurChar = '\' then
    begin
      CurrentChunk := CurrentChunk + '\';
      NextChar;
      exit;
    end;

    if CurrentChunk <> '' then
      AddStringChunk;

    Command := '';
    while (CurChar <> '{') and (CurPos <= Length(FormattedString)) do
    begin
      Command := Command + CurChar;
      NextChar;
    end;

    if CurChar = '{' then
    begin
      PossibleErrorPos := CurPos;
      NextChar;
      Parameter := '';
      while (CurChar <> '}') and (CurPos <= Length(FormattedString)) do
      begin
        Parameter := Parameter + CurChar;
        NextChar;
      end;

      if CurChar = '}' then
      begin
        Command := AnsiUpperCase(Command);

        Data := nil;
        CommandType := fcNoCommand;

        if Command = 'COLOR' then
        begin
          try
            Data := Pointer(StringToColor(Parameter));
            CommandType := fcColor;
          except
            CommandType := fcNoCommand;
            ErrorFound := True;
          end;
        end
        else if Command = 'COLUMN' then
        begin
          if Parameter <> '' then
          begin
            CommandType := fcNoCommand;
            ErrorFound := True;
          end
          else
            CommandType := fcColumn;
        end
        else if Command = 'HSPACE' then
        begin
          try
            Data := Pointer(StrToInt(Parameter));
            CommandType := fcHSpace;
          except
            CommandType := fcNoCommand;
            ErrorFound := True;
          end;
        end
        else if Command = 'IMAGE' then
        begin
          try
            Data := Pointer(StrToInt(Parameter));
            CommandType := fcImage;
          except
            CommandType := fcNoCommand;
            ErrorFound := True;
          end;
        end
        else if Command = 'STYLE' then
        begin
          if (Length(Parameter) = 2) and CharInSet(Parameter[1],
            ['+', '-', '~']) and CharInSet(UpCase(Parameter[2]),
            ['B', 'I', 'U', 'S']) then
          begin
            CommandType := fcStyle;
            if not(fcStyle in StripCommands) then
            begin
              Data := New(PFormatStyleData);
              PFormatStyleData(Data)^.Style := UpCase(Parameter[2]);
              case Parameter[1] of
                '+':
                  PFormatStyleData(Data)^.Action := 1;
                '-':
                  PFormatStyleData(Data)^.Action := -1;
                '~':
                  PFormatStyleData(Data)^.Action := 0;
              end;
            end;
          end
          else
          begin
            CommandType := fcNoCommand;
            ErrorFound := True;
          end;
        end
        else
          ErrorFound := True;

        if (CommandType <> fcNoCommand) and (not(CommandType in StripCommands))
          then
          AddCommandChunk(CommandType, Data);

        NextChar;
      end;
    end;
    Result := not ErrorFound;
  end;

  procedure ParseString;
  begin
    Assert(CurChar <> '\');
    while (CurChar <> '\') and (CurPos <= Length(FormattedString)) do
    begin
      CurrentChunk := CurrentChunk + CurChar;
      NextChar;
    end;
  end;

begin
  Assert(Assigned(ChunkList));

  if FormattedString = '' then
    exit;

  ErrorFound := False;
  CurrentChunk := '';
  CurPos := 1;
  CurChar := FormattedString[1];

  while CurPos <= Length(FormattedString) do
  begin
    if CurChar = '\' then
      ParseEscapeSequence
    else
      ParseString;
  end;

  if CurrentChunk <> '' then
    AddStringChunk;
end;

function StripFormatCommands(const FormattedString: string): string;
var
  Chunks: TFormatChunkList;
  i: Integer;
begin
  Chunks := TFormatChunkList.Create;
  try
    ParseFormatChunks(FormattedString, Chunks, AllCommands);

    Result := '';
    for i := 0 to Chunks.Count - 1 do
      Result := Result + Chunks[i]^.Str;

  finally
    Chunks.Free;
  end;
end;

function PaintChunks(TargetCanvas: TCanvas; const Rect: TRect;
  ChunkList: TFormatChunkList; Columns: TProposalColumns; Images: TImageList;
  Invisible: Boolean): Integer;
var
  i: Integer;
  x: Integer;
  C: PFormatChunk;
  CurrentColumn: TProposalColumn;
  CurrentColumnIndex: Integer;
  LastColumnStart: Integer;
  Style: TFontStyles;
  OldFont: TFont;
begin
  OldFont := TFont.Create;
  try
    OldFont.Assign(TargetCanvas.Font);

    if Assigned(Columns) and (Columns.Count > 0) then
    begin
      CurrentColumnIndex := 0;
      CurrentColumn := TProposalColumn(Columns.Items[0]);
      TargetCanvas.Font.Style := CurrentColumn.FFontStyle;
    end
    else
    begin
      CurrentColumnIndex := -1;
      CurrentColumn := nil;
    end;

    LastColumnStart := Rect.Left;
    x := Rect.Left;

    TargetCanvas.Brush.Style := bsClear;

    for i := 0 to ChunkList.Count - 1 do
    begin
      C := ChunkList[i];

      case C^.Command of
        fcNoCommand:
          begin
            if not Invisible then
              TargetCanvas.TextOut(x, Rect.Top, C^.Str);

            inc(x, TargetCanvas.TextWidth(C^.Str));
            if x > Rect.Right then
              break;
          end;
        fcColor:
          if not Invisible then
            TargetCanvas.Font.Color := TColor(C^.Data);
        fcStyle:
          begin
            case PFormatStyleData(C^.Data)^.Style of
              'I':
                Style := [fsItalic];
              'B':
                Style := [fsBold];
              'U':
                Style := [fsUnderline];
              'S':
                Style := [fsStrikeout];
            else
              Assert(False);
            end;

            case PFormatStyleData(C^.Data)^.Action of
              - 1:
                TargetCanvas.Font.Style := TargetCanvas.Font.Style - Style;
              0:
                if TargetCanvas.Font.Style * Style = [] then
                  TargetCanvas.Font.Style := TargetCanvas.Font.Style + Style
                else
                  TargetCanvas.Font.Style := TargetCanvas.Font.Style - Style;
              1:
                TargetCanvas.Font.Style := TargetCanvas.Font.Style + Style;
            else
              Assert(False);
            end;
          end;
        fcColumn:
          if Assigned(Columns) and (Columns.Count > 0) then
          begin
            if CurrentColumnIndex <= Columns.Count - 1 then
            begin
              inc(LastColumnStart,
                TargetCanvas.TextWidth(CurrentColumn.FBiggestWord + ' '));
              x := LastColumnStart;

              inc(CurrentColumnIndex);
              if CurrentColumnIndex <= Columns.Count - 1 then
              begin
                CurrentColumn := TProposalColumn
                  (Columns.Items[CurrentColumnIndex]);
                TargetCanvas.Font.Style := CurrentColumn.FFontStyle;
              end
              else
                CurrentColumn := nil;
            end;
          end;
        fcHSpace:
          begin
            inc(x, Integer(C^.Data));
            if x > Rect.Right then
              break;
          end;
        fcImage:
          begin
            Assert(Assigned(Images));

            Images.Draw(TargetCanvas, x, Rect.Top, Integer(C^.Data));

            inc(x, Images.Width);
            if x > Rect.Right then
              break;
          end;
      end;
    end;

    Result := x;
    TargetCanvas.Font.Assign(OldFont);
  finally
    OldFont.Free;
    TargetCanvas.Brush.Style := bsSolid;
  end;
end;

procedure FormattedTextOut(TargetCanvas: TCanvas; const Rect: TRect;
  const Text: string; Selected: Boolean; Columns: TProposalColumns;
  Images: TImageList);
var
  Chunks: TFormatChunkList;
  StripCommands: TFormatCommands;
begin
  Chunks := TFormatChunkList.Create;
  try
    if Selected then
      StripCommands := [fcColor]
    else
      StripCommands := [];

    ParseFormatChunks(Text, Chunks, StripCommands);
    PaintChunks(TargetCanvas, Rect, Chunks, Columns, Images, False);
  finally
    Chunks.Free;
  end;
end;

function FormattedTextWidth(TargetCanvas: TCanvas; const Text: string;
  Columns: TProposalColumns; Images: TImageList): Integer;
var
  Chunks: TFormatChunkList;
  TmpRect: TRect;
begin
  Chunks := TFormatChunkList.Create;
  try
    TmpRect := Rect(0, 0, MaxInt, MaxInt);

    ParseFormatChunks(Text, Chunks, [fcColor]);
    Result := PaintChunks(TargetCanvas, TmpRect, Chunks, Columns, Images, True);
  finally
    Chunks.Free;
  end;
end;

function PrettyTextToFormattedString(const APrettyText: string;
  AlternateBoldStyle: Boolean = False): string;
var
  i: Integer;
  Color: TColor;
begin
  Result := '';
  i := 1;
  while i <= Length(APrettyText) do
    case APrettyText[i] of
      #1, #2:
        begin
          Color := (Ord(APrettyText[i + 3]) shl 8 + Ord(APrettyText[i + 2]))
            shl 8 + Ord(APrettyText[i + 1]);

          Result := Result + '\color{' + ColorToString(Color) + '}';

          inc(i, 4);
        end;
      #3:
        begin
          if CharInSet(UpCase(APrettyText[i + 1]), ['B', 'I', 'U']) then
          begin
            Result := Result + '\style{';

            case APrettyText[i + 1] of
              'B':
                Result := Result + '+B';
              'b':
                Result := Result + '-B';
              'I':
                Result := Result + '+I';
              'i':
                Result := Result + '-I';
              'U':
                Result := Result + '+U';
              'u':
                Result := Result + '-U';
            end;

            Result := Result + '}';
          end;
          inc(i, 2);
        end;
      #9:
        begin
          Result := Result + '\column{}';
          if AlternateBoldStyle then
            Result := Result + '\style{~B}';
          inc(i);
        end;
    else
      Result := Result + APrettyText[i];
      inc(i);
    end;
end;


// TProposalColumn

constructor TProposalColumn.Create(Collection: TCollection);
begin
  inherited;
  FBiggestWord := 'CONSTRUCTOR';
  FInternalWidth := -1;
  FFontStyle := [];
end;

destructor TProposalColumn.Destroy;
begin
  inherited;
end;

procedure TProposalColumn.Assign(Source: TPersistent);
begin
  if Source is TProposalColumn then
  begin
    FBiggestWord := TProposalColumn(Source).FBiggestWord;
    FInternalWidth := TProposalColumn(Source).FInternalWidth;
    FFontStyle := TProposalColumn(Source).FFontStyle;
  end
  else
    inherited Assign(Source);
end;

constructor TProposalColumns.Create(AOwner: TPersistent;
  ItemClass: TCollectionItemClass);
begin
  inherited Create(ItemClass);
  FOwner := AOwner;
end;

function TProposalColumns.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TProposalColumns.GetItem(index: Integer): TProposalColumn;
begin
  Result := inherited GetItem(index) as TProposalColumn;
end;

procedure TProposalColumns.SetItem(index: Integer; Value: TProposalColumn);
begin
  inherited SetItem(index, Value);
end;

function TProposalColumns.Add: TProposalColumn;
begin
  Result := inherited Add as TProposalColumn;
end;

function TProposalColumns.FindItemID(ID: Integer): TProposalColumn;
begin
  Result := inherited FindItemID(ID) as TProposalColumn;
end;

function TProposalColumns.Insert(index: Integer): TProposalColumn;
begin
  Result := inherited Insert(index) as TProposalColumn;
end;


// ============================================================================

// GBN 10/11/2001
// Moved from completion component
function FormatParamList(const s: string; CurrentIndex: Integer): string;
var
  i: Integer;
  List: TStrings;
begin
  Result := '';
  List := TStringList.Create;
  try
    List.CommaText := s;
    for i := 0 to List.Count - 1 do
    begin
      if i = CurrentIndex then
        Result := Result + '\style{~B}' + List[i] + '\style{~B}'
      else
        Result := Result + List[i];

      if i < List.Count - 1 then
        // Result := Result + ', ';
        Result := Result + ' ';
    end;
  finally
    List.Free;
  end;
end;
// End GBN 10/11/2001

{ TSynBaseCompletionProposalForm }

constructor TSynBaseCompletionProposalForm.Create(AOwner: TComponent);
begin
  FResizeable := True;
  CreateNew(AOwner);
  Bitmap := TBitmap.Create;
  TitleBitmap := TBitmap.Create;
  FItemList := TStringList.Create;
  FInsertList := TStringList.Create;
  FAssignedList := TStringList.Create;
  FMatchText := False;
  BorderStyle := bsNone;
  FScrollbar := TScrollBar.Create(Self);
  FScrollbar.ControlStyle := FScrollbar.ControlStyle - [csFramed];
  FScrollbar.TabStop := False;
  FScrollbar.Kind := sbVertical;
  FScrollbar.OnChange := ScrollbarOnChange;
  FScrollbar.OnScroll := ScrollbarOnScroll;
  FScrollbar.OnEnter := ScrollbarOnEnter;
  FScrollbar.Parent := Self;
  Visible := False;

  FTitleFont := TFont.Create;
  FTitleFont.name := 'MS Sans Serif';
  FTitleFont.Size := 8;
  FTitleFont.Style := [fsBold];
  FTitleFont.Color := clBtnText;

  FFont := TFont.Create;
  FFont.name := 'MS Sans Serif';
  FFont.Size := 8;

  ClSelect := clHighlight;
  ClSelectedText := clHighlightText;
  ClBackground := clWindow;
  ClTitleBackground := clBtnFace;

(FItemList as TStringList)
  .OnChange := StringListChange; // Really necessary? It seems to work
  FTitle := ''; // fine without it
  FUseInsertList := False;
  FFormattedText := False;
  FCenterTitle := True;
  FAnsi := True;
  FCase := False;

  FColumns := TProposalColumns.Create(AOwner, TProposalColumn);

  FItemHeight := 0;
  FMargin := 2;
  FEffectiveItemHeight := 0;
  RecalcItemHeight;

  Canvas.Font.Assign(FTitleFont);
  FTitleFontHeight := Canvas.TextHeight(TextHeightString);
  FHeightBuffer := 0;

  FTitleFont.OnChange := TitleFontChange;
  FFont.OnChange := FontChange;

  OnDblClick := DoDoubleClick;
  OnShow := DoFormShow;
  OnHide := DoFormHide;
end;

procedure TSynBaseCompletionProposalForm.CreateParams
  (var Params: TCreateParams);
const
  CS_DROPSHADOW = $20000;
begin
  inherited;
  with Params do
  begin
    Style := WS_POPUP;
    ExStyle := WS_EX_TOOLWINDOW;

    if ((Win32Platform and VER_PLATFORM_WIN32_NT) <> 0) and
      (Win32MajorVersion > 4) and (Win32MinorVersion > 0) { Windows XP } then
      Params.WindowClass.Style := Params.WindowClass.Style or CS_DROPSHADOW;

    if DisplayType = ctCode then
      if FResizeable then
        Style := Style or WS_THICKFRAME
      else
        Style := Style or WS_DLGFRAME;
  end;
end;

procedure TSynBaseCompletionProposalForm.Activate;
begin
  Visible := True;
  FMouseOverIndex := -1;
end;

procedure TSynBaseCompletionProposalForm.Deactivate;
begin
  Visible := False;
end;

destructor TSynBaseCompletionProposalForm.Destroy;
begin
  inherited Destroy;
  FColumns.Free;
  Bitmap.Free;
  TitleBitmap.Free;
  FItemList.Free;
  FInsertList.Free;
  FAssignedList.Free;
  FTitleFont.Free;
  FFont.Free;
end;

procedure TSynBaseCompletionProposalForm.KeyDown(var Key: Word;
  Shift: TShiftState);
var
  C: Char;
  TmpOffset: Integer;
  BC: TBufferCoord;
  pt, ptc: TPoint;
begin
  if DisplayType = ctCode then
  begin
    case Key of
      VK_RETURN:
        begin
          Key := 0;
        end;
      VK_TAB:
        if (FCompleteWithTab) and Assigned(OnValidate) then
        begin
          C := #0;
          OnValidate(Self, Shift, C);
        end;
      VK_ESCAPE:
        begin
          if Assigned(OnCancel) then
            OnCancel(Self);
          Key := 0;
        end;
      VK_BACK, VK_LEFT:
        begin
          if not(Key = VK_BACK) or (Shift = []) then
          begin
            if Length(FCurrentString) > 0 then
            begin
              if Assigned(CurrentEditor) then
              begin
                BC := (CurrentEditor as TEditor).CaretXY;
                Dec(BC.Char);
                pt := (CurrentEditor as TEditor).RowColumnToPixels
                  ((CurrentEditor as TEditor).BufferToDisplayPos(BC));
                TmpOffset := (CurrentEditor as TEditor).TextWidth
                  (STYLE_DEFAULT, Copy(CurrentString, Length(CurrentString),
                    1));
                ptc := (CurrentEditor as TEditor).ScreenToClient
                  (Point(Left, Top));
                if ptc.x > pt.x then
                  Left := Left - TmpOffset;
              end;
              CurrentString := Copy(CurrentString, 1,
                Length(CurrentString) - 1);
            end
            else
            begin
              if Assigned(OnCancel) then
                OnCancel(Self);
            end;
          end;
        end;
      VK_RIGHT:
        begin
          if Assigned(CurrentEditor) then
            with CurrentEditor as TEditor do
            begin
              if CaretX <= Length(LineText) then
                C := Char(LineText[CaretX])
              else
                C := #32;

              if (C = #9) or (C = #32) or
                (((FScanChars = []) and not CharInSet(C,
                    DefaulTSynIdentChars)) or CharInSet(C, FScanChars)) then
                if Assigned(OnCancel) then
                  OnCancel(Self)
                else
                else
                  CurrentString := CurrentString + C;
            end;
        end;
      VK_PRIOR:
      begin
        MoveLine(FLinesInWindow * -1);
        Key := 0;
      end;
      VK_NEXT:
      begin
        MoveLine(FLinesInWindow);
        Key := 0;
      end;
      VK_END:
      begin
        Position := FAssignedList.Count - 1;
        Key := 0;
      end;
      VK_HOME:
      begin
        Position := 0;
        Key := 0;
      end;
      VK_UP:
        begin
          if ssCtrl in Shift then
            Position := 0
          else
            MoveLine(-1);
          Key := 0;
        end;
      VK_DOWN:
        begin
          if ssCtrl in Shift then
            Position := FAssignedList.Count - 1
          else
            MoveLine(1);
          Key := 0;
        end;
    end;
  end;
  Invalidate;
end;

procedure TSynBaseCompletionProposalForm.KeyPress(var Key: Char);
var
  C: Char;
begin
  if DisplayType = ctCode then
  begin
    case Key of
      #13:
        if (FCompleteWithEnter) and Assigned(OnValidate) then
        begin
          C := #0;
          Key := #0;
          OnValidate(Self, KeyboardStateToShiftState, C); // GBN 15/11/2001
        end;
      #27:
        ; // These keys are already handled by KeyDown
      #32 .. 'z':
        begin
          if CharInSet(Key, FWordBreakChars) and Assigned(OnValidate) then
          begin
            if Key = #32 then
            begin
              C := #0;
              OnValidate(Self, [], C);
            end
            else
              OnValidate(Self, [], Key);
          end;
          if (Key = #32) and ([ssCtrl] = KeyboardStateToShiftState) then
            exit;
          CurrentString := CurrentString + Key;
          if (FAssignedList.Count = 0) and Assigned(OnCancel) then
            OnCancel(Self);
          if Assigned(OnKeyPress) then
            OnKeyPress(Self, Key);
        end;
      #8:
        if Assigned(OnKeyPress) then
          OnKeyPress(Self, Key);
    else
      if Assigned(OnCancel) then
        OnCancel(Self);
    end;
  end;
  Invalidate;
end;

procedure TSynBaseCompletionProposalForm.MouseDown(Button: TMouseButton;
  Shift: TShiftState; x, y: Integer);
begin
  y := (y - FHeightBuffer) div FEffectiveItemHeight;
  Position := FScrollbar.Position + y;
  // (CurrentEditor as TEditor).UpdateCaret;
end;

function TSynBaseCompletionProposalForm.CanResize(var NewWidth,
  NewHeight: Integer): Boolean;
var
  NewLinesInWindow: Integer;
  BorderWidth: Integer;
begin
  Result := True;
  case FDisplayKind of
    ctCode:
      begin
        BorderWidth := 2 * GetSystemMetrics(SM_CYSIZEFRAME);

        if FEffectiveItemHeight <> 0 then
        begin
          // ### Falcon C++ Changes -- Bug Fixed
          NewLinesInWindow := (NewHeight - FHeightBuffer - BorderWidth)
            div FEffectiveItemHeight;
          // ### End Falcon C++ Changes
          if NewLinesInWindow < 1 then
            NewLinesInWindow := 1;
        end
        else
          NewLinesInWindow := 0;

        FLinesInWindow := NewLinesInWindow;

        NewHeight := FEffectiveItemHeight * FLinesInWindow + FHeightBuffer +
          BorderWidth;

        if (NewWidth - BorderWidth) < FScrollbar.Width then
          NewWidth := FScrollbar.Width + BorderWidth;
      end;
    ctHint:
      ;
    ctParams:
      ;
  end;
end;

procedure TSynBaseCompletionProposalForm.Resize;
begin
  inherited;

  if FEffectiveItemHeight <> 0 then
    FLinesInWindow := (Height - FHeightBuffer) div FEffectiveItemHeight;

  if not(csCreating in ControlState) then
    AdjustMetrics;

  AdjustScrollBarPosition;
  Invalidate;
end;

procedure TSynBaseCompletionProposalForm.Paint;

  procedure ResetCanvas;
  begin
    with Bitmap.Canvas do
    begin
      Pen.Color := fClBackGround;
      Brush.Color := fClBackGround;
      Font.Assign(FFont);
    end;
  end;

const
  TitleMargin = 2;
{$IF CompilerVersion < 19}
  TREIS_HOTSELECTED = 6;
{$IFEND}
var
  TmpRect, RowRect: TRect;
  TmpX: Integer;
  AlreadyDrawn: Boolean;
  TmpString: string;
  i: Integer;
  Theme: HTHEME;
begin
  if FDisplayKind = ctCode then
  begin
    Theme := 0;
    if UseThemes then
      Theme := OpenThemeData(Application.
        {$IF CompilerVersion >= 20} ActiveFormHandle {$ELSE} Handle
        {$IFEND}, 'Explorer::TreeView');
    with Bitmap do
    begin
      ResetCanvas;
      Canvas.Pen.Color := clBtnFace;
      Canvas.Rectangle(0, 0, ClientWidth - FScrollbar.Width, ClientHeight);
      for i := 0 to Min(FLinesInWindow - 1, FAssignedList.Count - 1) do
      begin
        if (i + FScrollbar.Position = Position) or (i = FMouseOverIndex) then
        begin
          Canvas.Brush.Color := FClSelect;
          Canvas.Pen.Color := FClSelect;
          // ##Falcon C++ Changes
          if UseThemes and (Theme <> 0) then
          begin
            RowRect := Rect(0, FEffectiveItemHeight * i,
              ClientWidth - FScrollbar.Width, FEffectiveItemHeight * (i + 1));
            if i = FMouseOverIndex then
            begin
              DrawThemeBackground(Theme, Canvas.Handle, TVP_TREEITEM,
                IfThen(i + FScrollbar.Position = Position, TREIS_SELECTED,
                  TREIS_HOT), RowRect, nil);
            end
            else
              DrawThemeBackground(Theme, Canvas.Handle, TVP_TREEITEM,
                IfThen(Self.Focused, TREIS_SELECTED, TREIS_SELECTEDNOTFOCUS),
                RowRect, nil);
          end
          else
          begin
            if (i + FScrollbar.Position <> Position) and (i = FMouseOverIndex)
              then
            begin
              Canvas.Brush.Color := $FDF5EF;
              Canvas.Pen.Color := $FDF5EF;
            end;
            Canvas.Rectangle(0, FEffectiveItemHeight * i,
              ClientWidth - FScrollbar.Width, FEffectiveItemHeight * (i + 1));
          end;
          // ##End Falcon C++ Changes
          Canvas.Pen.Color := fClSelectText;
          Canvas.Font.Assign(FFont);
          if UseThemes and (Theme <> 0) then
            Canvas.Font.Color := fClSelectText
          else
            Canvas.Font.Color := clWindow;
        end;

        AlreadyDrawn := False;

        if Assigned(OnPaintItem) then
          OnPaintItem(Self, LogicalToPhysicalIndex(FScrollbar.Position + i),
            Canvas, Rect(0, FEffectiveItemHeight * i,
              ClientWidth - FScrollbar.Width, FEffectiveItemHeight * (i + 1)),
            AlreadyDrawn);

        if AlreadyDrawn then
          ResetCanvas
        else
        begin
          if FFormattedText then
          begin
            FormattedTextOut(Canvas, Rect(FMargin,
                FEffectiveItemHeight * i +
                  ((FEffectiveItemHeight - FFontHeight) div 2),
                Bitmap.Width, FEffectiveItemHeight * (i + 1)),
              FAssignedList[FScrollbar.Position + i],
              (i + FScrollbar.Position = Position), FColumns, FImages);
          end
          else
          begin
            Canvas.TextOut(FMargin, FEffectiveItemHeight * i,
              FAssignedList[FScrollbar.Position + i]);
          end;

          if i + FScrollbar.Position = Position then
            ResetCanvas;
        end;
      end;
    end;
    if UseThemes then
      CloseThemeData(Theme);
    Canvas.Draw(0, FHeightBuffer, Bitmap);

    if FTitle <> '' then
    begin
      with TitleBitmap do
      begin
        Canvas.Brush.Color := FClTitleBackground;
        TmpRect := Rect(0, 0, ClientWidth + 1, FHeightBuffer); // GBN
        Canvas.FillRect(TmpRect);
        Canvas.Pen.Color := clBtnShadow;
        Dec(TmpRect.Bottom, 1);
        Canvas.PenPos := TmpRect.BottomRight;
        Canvas.LineTo(TmpRect.Left - 1, TmpRect.Bottom);
        Canvas.Pen.Color := clBtnFace;

        Canvas.Font.Assign(FTitleFont);

        if CenterTitle then
        begin
          TmpX := (Width - Canvas.TextWidth(Title)) div 2;
          if TmpX < TitleMargin then
            TmpX := TitleMargin; // We still want to be able to read it, even if it does go over the edge
        end
        else
        begin
          TmpX := TitleMargin;
        end;
        Canvas.TextRect(TmpRect, TmpX, TitleMargin - 1, FTitle);
        // -1 because TmpRect.Top is already 1
      end;
      Canvas.Draw(0, 0, TitleBitmap);
    end;
  end
  else if (FDisplayKind = ctHint) or (FDisplayKind = ctParams) then
  begin
    with Bitmap do
    begin
      ResetCanvas;
      TmpRect := Rect(0, 0, ClientWidth, ClientHeight);
      Canvas.FillRect(TmpRect);
      Frame3D(Canvas, TmpRect, cl3DLight, cl3DDkShadow, 1);

      // GBN 10/11/2001
      for i := 0 to FAssignedList.Count - 1 do
      begin
        AlreadyDrawn := False;
        if Assigned(OnPaintItem) then
          OnPaintItem(Self, i, Canvas, Rect(0,
              FEffectiveItemHeight * i + FMargin, ClientWidth,
              FEffectiveItemHeight * (i + 1) + FMargin), AlreadyDrawn);

        if AlreadyDrawn then
          ResetCanvas
        else
        begin
          if FDisplayKind = ctParams then
            TmpString := FormatParamList(FAssignedList[i], CurrentIndex)
          else
            TmpString := FAssignedList[i];

          FormattedTextOut(Canvas, Rect(FMargin + 1,
              FEffectiveItemHeight * i + ((FEffectiveItemHeight - FFontHeight)
                  div 2) + FMargin, Bitmap.Width - 1,
              FEffectiveItemHeight * (i + 1) + FMargin), TmpString, False,
            nil, FImages);
        end;
      end;
      // End GBN 10/11/2001
    end;
    Canvas.Draw(0, 0, Bitmap);
  end;
end;

procedure TSynBaseCompletionProposalForm.ScrollbarOnChange(Sender: TObject);
begin
  if Position < FScrollbar.Position then
    Position := FScrollbar.Position
  else if Position > FScrollbar.Position + FLinesInWindow - 1 then
    Position := FScrollbar.Position + FLinesInWindow - 1
  else
    Repaint;
end;

procedure TSynBaseCompletionProposalForm.ScrollbarOnScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
end;

procedure TSynBaseCompletionProposalForm.ScrollbarOnEnter(Sender: TObject);
begin
  ActiveControl := nil;
end;

procedure TSynBaseCompletionProposalForm.MoveLine(cnt: Integer);
begin
  if (cnt > 0) then
  begin
    if (Position < (FAssignedList.Count - cnt)) then
      Position := Position + cnt
    else
      Position := FAssignedList.Count - 1;
  end
  else
  begin
    if (Position + cnt) > 0 then
      Position := Position + cnt
    else
      Position := 0;
  end;
end;

function TSynBaseCompletionProposalForm.LogicalToPhysicalIndex(index: Integer)
  : Integer;
begin
  if FMatchText and (index >= 0) and (index < FAssignedList.Count) then
    Result := Integer(FAssignedList.Objects[index])
  else
    Result := index;
end;

function TSynBaseCompletionProposalForm.PhysicalToLogicalIndex(index: Integer)
  : Integer;
var
  i: Integer;
begin
  if FMatchText then
  begin
    Result := -1;
    for i := 0 to FAssignedList.Count - 1 do
      if Integer(FAssignedList.Objects[i]) = index then
      begin
        Result := i;
        break;
      end;
  end
  else
    Result := index;
end;

procedure TSynBaseCompletionProposalForm.SetCurrentString(const Value: string);

  function MatchItem(AIndex, CurrIndex: Integer; var AIndexSelect: Integer;
    var EqSelected: Boolean; UseItemList: Boolean): Boolean;
  var
    CompareString, ACompareString: string;
  begin
    if UseInsertList then
      ACompareString := FInsertList[AIndex]
    else
    begin
      if (FMatchText) and (not UseItemList) then
        ACompareString := FAssignedList[AIndex]
      else
        ACompareString := FItemList[AIndex]; // GBN 29/08/2002 Fix for when match text is not active

      if UsePrettyText then
        ACompareString := StripFormatCommands(CompareString);
    end;
    CompareString := Copy(ACompareString, 1, Length(Value));
    if FAnsi then
    begin
      if FCase then
        Result := AnsiCompareStr(CompareString, Value) = 0
      else
        Result := AnsiCompareText(CompareString, Value) = 0;
    end
    else
    begin
      if FCase then
        Result := CompareStr(CompareString, Value) = 0
      else
        Result := CompareText(CompareString, Value) = 0;
    end;
    if Result and (Length(Value) = Length(ACompareString)) then
    begin
      if (AIndexSelect = -1) then
        AIndexSelect := CurrIndex;
      if not EqSelected and (Value = ACompareString) then
      begin
        EqSelected := True;
        AIndexSelect := CurrIndex;
      end;
    end;
  end;

  procedure RecalcList(var AIndexSelect: Integer);
  var
    i, CurrIndex: Integer;
    EqSelected: Boolean;
  begin
    FAssignedList.Clear;
    CurrIndex := 0;
    EqSelected := False;
    for i := 0 to FItemList.Count - 1 do
    begin
      if MatchItem(i, CurrIndex, AIndexSelect, EqSelected, True) then
      begin
        FAssignedList.AddObject(FItemList[i], TObject(i));
        inc(CurrIndex);
      end;
    end;
  end;

var
  i, SelIndex: Integer;
  EqSelected: Boolean;
begin
  FCurrentString := Value;
  if DisplayType <> ctCode then
    exit;
  if FMatchText then
  begin
    SelIndex := -1;
    RecalcList(SelIndex);
    AdjustScrollBarPosition;
    if SelIndex >= 0 then
      Position := SelIndex
    else
      Position := 0;
    if Visible and Assigned(FOnChangePosition) and (DisplayType = ctCode) then
      FOnChangePosition(Owner as TSynBaseCompletionProposal,
        LogicalToPhysicalIndex(FPosition));

    Repaint;
  end
  else
  begin
    i := 0;
    EqSelected := False;
    while (i < ItemList.Count) and (not MatchItem(i, 0, SelIndex, EqSelected,
        True)) do
      inc(i);
    if i < ItemList.Count then
      Position := i
    else
      Position := 0;
  end;
end;

procedure TSynBaseCompletionProposalForm.SetItemList(const Value: TStrings);
begin
  FItemList.Assign(Value);
  FAssignedList.Assign(Value);
  CurrentString := CurrentString;
end;

procedure TSynBaseCompletionProposalForm.SetInsertList(const Value: TStrings);
begin
  FInsertList.Assign(Value);
end;

procedure TSynBaseCompletionProposalForm.DoDoubleClick(Sender: TObject);
var
  C: Char;
begin
  C := #0;
  // we need to do the same as the enter key;
  if DisplayType = ctCode then
    if Assigned(OnValidate) then
      OnValidate(Self, [], C); // GBN 15/11/2001
end;

procedure TSynBaseCompletionProposalForm.SetPosition(const Value: Integer);
begin
  if ((Value <= 0) and (FPosition = 0)) or (FPosition = Value) then
    exit;

  if Value <= FAssignedList.Count - 1 then
  begin
    FPosition := Value;
    if Position < FScrollbar.Position then
      FScrollbar.Position := Position
    else if FScrollbar.Position < (Position - FLinesInWindow + 1) then
      FScrollbar.Position := Position - FLinesInWindow + 1;

    if Visible and Assigned(FOnChangePosition) and (DisplayType = ctCode) then
      FOnChangePosition(Owner as TSynBaseCompletionProposal,
        LogicalToPhysicalIndex(FPosition));

    Repaint;
  end;
end;

procedure TSynBaseCompletionProposalForm.SetResizeable(const Value: Boolean);
begin
  FResizeable := Value;
  RecreateWnd;
end;

procedure TSynBaseCompletionProposalForm.SetItemHeight(const Value: Integer);
begin
  if Value <> FItemHeight then
  begin
    FItemHeight := Value;
    RecalcItemHeight;
  end;
end;

procedure TSynBaseCompletionProposalForm.SetImages(const Value: TImageList);
begin
  if FImages <> Value then
  begin
    if Assigned(FImages) then
      FImages.RemoveFreeNotification(Self);

    FImages := Value;
    if Assigned(FImages) then
      FImages.FreeNotification(Self);
  end;
end;

procedure TSynBaseCompletionProposalForm.RecalcItemHeight;
begin
  Canvas.Font.Assign(FFont);
  FFontHeight := Canvas.TextHeight(TextHeightString);
  if FItemHeight > 0 then
    FEffectiveItemHeight := FItemHeight
  else
  begin
    FEffectiveItemHeight := FFontHeight;
  end;
end;

function TSynBaseCompletionProposalForm.ItemIndexAt(const P: TPoint): Integer;
var
  i: Integer;
begin
  Result := -1;
  if (FEffectiveItemHeight = 0) or (P.x < 0) or (P.x > ClientWidth) then
    exit;
  i := P.y div FEffectiveItemHeight;
  if (i >= 0) and (i < FAssignedList.Count) then
    Result := i;
end;

procedure TSynBaseCompletionProposalForm.StringListChange(Sender: TObject);
begin
  FScrollbar.Position := Position;
end;

procedure TSynBaseCompletionProposalForm.WMMouseWheel(var Msg: TMessage);
var
  nDelta: Integer;
  nWheelClicks: Integer;
const
  LinesToScroll = 3;
  WHEEL_DELTA = 120;
  WHEEL_PAGESCROLL = MAXDWORD;
  SPI_GETWHEELSCROLLLINES = 104;
begin
  if csDesigning in ComponentState then
    exit;

  if GetKeyState(VK_CONTROL) >= 0 then
    nDelta := Mouse.WheelScrollLines
  else
    nDelta := FLinesInWindow;

  inc(FMouseWheelAccumulator, SmallInt(Msg.wParamHi));
  nWheelClicks := FMouseWheelAccumulator div WHEEL_DELTA;
  FMouseWheelAccumulator := FMouseWheelAccumulator mod WHEEL_DELTA;
  if (nDelta = Integer(WHEEL_PAGESCROLL)) or (nDelta > FLinesInWindow) then
    nDelta := FLinesInWindow;
  if Position - (nDelta * nWheelClicks) < 0 then
    nDelta := Position
  else if Position - (nDelta * nWheelClicks) >= FAssignedList.Count then
    nDelta := FAssignedList.Count - Position - 1;
  Position := Position - (nDelta * nWheelClicks);
  // (CurrentEditor as TEditor).UpdateCaret;
end;

function GetMDIParent(const Form: TSynForm): TSynForm;
{ Returns the parent of the specified MDI child form. But, if Form isn't a
  MDI child, it simply returns Form. }
var
  i, J: Integer;
begin
  Result := Form;
  if Form = nil then
    exit;
  if (Form is TSynForm) and ((Form as TForm).FormStyle = fsMDIChild) then
    for i := 0 to Screen.FormCount - 1 do
      with Screen.Forms[i] do
      begin
        if FormStyle <> fsMDIForm then
          Continue;
        for J := 0 to MDIChildCount - 1 do
          if MDIChildren[J] = Form then
          begin
            Result := Screen.Forms[i];
            exit;
          end;
      end;
end;

procedure TSynBaseCompletionProposalForm.DoFormHide(Sender: TObject);
begin
  if CurrentEditor <> nil then
  begin
    if DisplayType = ctCode then
    begin (Owner as TSynBaseCompletionProposal)
      .FWidth := Width; (Owner as TSynBaseCompletionProposal)
      .FNbLinesInWindow := FLinesInWindow;
    end;
  end;
  // GBN 28/08/2002
  if Assigned((Owner as TSynBaseCompletionProposal).OnClose) then
    TSynBaseCompletionProposal(Owner).OnClose(Self);
end;

procedure TSynBaseCompletionProposalForm.DoFormShow(Sender: TObject);
begin
  // GBN 28/08/2002
  if Assigned((Owner as TSynBaseCompletionProposal).OnShow) then
  (Owner as TSynBaseCompletionProposal)
    .OnShow(Self);
end;

procedure TSynBaseCompletionProposalForm.WMEraseBackgrnd(var message: TMessage);
begin
  message.Result := 1;
end;

// GBN 24/02/2002
procedure TSynBaseCompletionProposalForm.WMGetDlgCode
  (var message: TWMGetDlgCode);
begin
  inherited;
  message.Result := message.Result or DLGC_WANTTAB;
end;

procedure TSynBaseCompletionProposalForm.AdjustMetrics;
begin
  if DisplayType = ctCode then
  begin
    if FTitle <> '' then
      FHeightBuffer := FTitleFontHeight + 4 { Margin }
    else
      FHeightBuffer := 0;

    if (ClientWidth >= FScrollbar.Width) and (ClientHeight >= FHeightBuffer)
      then
    begin
      Bitmap.Width := ClientWidth - FScrollbar.Width;
      Bitmap.Height := ClientHeight - FHeightBuffer;
    end;

    if (ClientWidth > 0) and (FHeightBuffer > 0) then
    begin
      TitleBitmap.Width := ClientWidth;
      TitleBitmap.Height := FHeightBuffer;
    end;
  end
  else
  begin
    if (ClientWidth > 0) and (ClientHeight > 0) then
    begin
      Bitmap.Width := ClientWidth;
      Bitmap.Height := ClientHeight;
    end;
  end;
end;

procedure TSynBaseCompletionProposalForm.AdjustScrollBarPosition;
begin
  if FDisplayKind = ctCode then
  begin
    if Assigned(FScrollbar) then
    begin
      FScrollbar.Top := FHeightBuffer;
      FScrollbar.Height := ClientHeight - FHeightBuffer;
      FScrollbar.Left := ClientWidth - FScrollbar.Width;

      if FAssignedList.Count - FLinesInWindow < 0 then
      begin
        FScrollbar.PageSize := 0;
        FScrollbar.Max := 0;
        FScrollbar.Enabled := False;
      end
      else
      begin
        FScrollbar.PageSize := 0;
        FScrollbar.Max := FAssignedList.Count - FLinesInWindow;
        if FScrollbar.Max <> 0 then
        begin
          FScrollbar.LargeChange := FLinesInWindow;
          FScrollbar.PageSize := 1;
          FScrollbar.Enabled := True;
        end
        else
          FScrollbar.Enabled := False;
      end;
    end;
  end;
end;

procedure TSynBaseCompletionProposalForm.SetTitle(const Value: string);
begin
  FTitle := Value;
  AdjustMetrics;
end;

procedure TSynBaseCompletionProposalForm.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
  RecalcItemHeight;
  AdjustMetrics;
end;

procedure TSynBaseCompletionProposalForm.SetTitleFont(const Value: TFont);
begin
  FTitleFont.Assign(Value);
  FTitleFontHeight := Canvas.TextHeight(TextHeightString);
  AdjustMetrics;
end;

procedure TSynBaseCompletionProposalForm.SetColumns(Value: TProposalColumns);
begin
  FColumns.Assign(Value);
end;

procedure TSynBaseCompletionProposalForm.TitleFontChange(Sender: TObject);
begin
  Canvas.Font.Assign(FTitleFont);
  FTitleFontHeight := Canvas.TextHeight(TextHeightString);
  AdjustMetrics;
end;

procedure TSynBaseCompletionProposalForm.FontChange(Sender: TObject);
begin
  RecalcItemHeight;
  AdjustMetrics;
end;

procedure TSynBaseCompletionProposalForm.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if AComponent = FImages then
      Images := nil;
  end;

  inherited Notification(AComponent, Operation);
end;

procedure TSynBaseCompletionProposalForm.HandleMouseMove(Shift: TShiftState;
  x, y: Integer);
begin
  y := (y - FHeightBuffer) div FEffectiveItemHeight;
  if (x < 0) or (x > Width) or (y < 0) or (y > Height) then
    y := -1;
  if y <> FMouseOverIndex then
  begin
    FMouseOverIndex := y;
    Repaint;
  end;
end;

procedure TSynBaseCompletionProposalForm.WMNCMouseMove
  (var message: TWMNCMouseMove);
var
  P: TPoint;
begin
  // hovering, mouse leave detection
  with TWMNCMouseMove(message) do
  begin
    P := ScreenToClient(Point(XCursor, YCursor));
    HandleMouseMove(KeyboardStateToShiftState, P.x, P.y);
  end;
end;

procedure TSynBaseCompletionProposalForm.WMMouseMove(var message: TWMMouseMove);
begin
  HandleMouseMove(KeyboardStateToShiftState, message.XPos, message.YPos);
end;

procedure TSynBaseCompletionProposalForm.CMMouseLeave(var message: TMessage);
begin
  inherited;
  FMouseOverIndex := -1;
  Repaint;
end;

{ TSynBaseCompletionProposal }

constructor TSynBaseCompletionProposal.Create(AOwner: TComponent);
begin
  FWidth := 260;
  FNbLinesInWindow := 8;
  inherited Create(AOwner);
  FForm := TSynBaseCompletionProposalForm.Create(Self);
  EndOfTokenChr := DefaultEndOfTokenChr;
  FDotOffset := 0;
  DefaultType := ctCode;
end;

procedure TSynBaseCompletionProposal.Execute(s: string; x, y: Integer);
begin
  ExecuteEx(s, x, y, DefaultType);
end;

procedure TSynBaseCompletionProposal.ExecuteEx(s: string; x, y: Integer;
  Kind: SynCompletionType);

  function GetWorkAreaWidth: Integer;
  begin
    Result := Screen.DesktopWidth;
  end;

  function GetWorkAreaHeight: Integer;
  begin
    Result := Screen.DesktopHeight;
  end;

  function GetParamWidth(const s: string): Integer;
  var
    i: Integer;
    List: TStringList;
    NewWidth: Integer;
  begin
    List := TStringList.Create;
    try
      List.CommaText := s;

      Result := 0;
      for i := -1 to List.Count - 1 do
      begin
        NewWidth := FormattedTextWidth(Form.Canvas, FormatParamList(s, i),
          Columns, FForm.Images);

        if NewWidth > Result then
          Result := NewWidth;
      end;
    finally
      List.Free;
    end;
  end;

  procedure RecalcFormPlacement;
  var
    i: Integer;
    tmpWidth: Integer;
    tmpHeight: Integer;
    TmpX: Integer;
    tmpY: Integer;
    tmpStr: string;
    BorderWidth: Integer;
    NewWidth: Integer;
  begin

    TmpX := x;
    tmpY := y;
    tmpWidth := 0;
    tmpHeight := 0;
    case Kind of
      ctCode:
        begin
          BorderWidth := 2 * GetSystemMetrics(SM_CYSIZEFRAME);

          tmpWidth := FWidth;
          tmpHeight := Form.FHeightBuffer + Form.FEffectiveItemHeight *
            FNbLinesInWindow + BorderWidth;
        end;
      ctHint:
        begin
          BorderWidth := 2;
          tmpHeight := Form.FEffectiveItemHeight * ItemList.Count +
            BorderWidth + 2 * Form.Margin;

          Form.Canvas.Font.Assign(Font);
          for i := 0 to ItemList.Count - 1 do
          begin
            tmpStr := ItemList[i];
            NewWidth := FormattedTextWidth(Form.Canvas, tmpStr, nil,
              FForm.Images);
            if NewWidth > tmpWidth then
              tmpWidth := NewWidth;
          end;

          inc(tmpWidth, 2 * FForm.Margin + BorderWidth);
        end;
      ctParams:
        begin
          BorderWidth := 2;
          tmpHeight := Form.FEffectiveItemHeight * ItemList.Count +
            BorderWidth + 2 * Form.Margin;

          Form.Canvas.Font.Assign(Font);
          for i := 0 to ItemList.Count - 1 do
          begin
            NewWidth := GetParamWidth(StripFormatCommands(ItemList[i]));

            if Assigned(Form.OnMeasureItem) then
              Form.OnMeasureItem(Self, i, Form.Canvas, NewWidth);

            if NewWidth > tmpWidth then
              tmpWidth := NewWidth;
          end;

          inc(tmpWidth, 2 * FForm.Margin + BorderWidth);
        end;
    end;

    if TmpX + tmpWidth > GetWorkAreaWidth then
    begin
      TmpX := GetWorkAreaWidth - tmpWidth - 5; // small space buffer
      if TmpX < 0 then
        TmpX := 0;
    end;

    if tmpY + tmpHeight > GetWorkAreaHeight then
    begin
      tmpY := tmpY - tmpHeight - (Form.CurrentEditor as TEditor).LineHeight - 2;
      if tmpY < 0 then
        tmpY := 0;
    end;

    Form.Width := tmpWidth;
    Form.Height := tmpHeight;
    Form.Top := tmpY;
    Form.Left := TmpX;
  end;

var
  TmpOffset: Integer;
begin
  DisplayType := Kind;

  FCanExecute := True;
  if Assigned(OnExecute) then
    OnExecute(Kind, Self, s, x, y, FCanExecute);

  if (not FCanExecute) or (ItemList.Count = 0) then
  begin
    if Form.Visible and (Kind = ctParams) then
      Form.Visible := False;
    exit;
  end;

  Form.FormStyle := fsStayOnTop;

  if Assigned(Form.CurrentEditor) then
  begin
    TmpOffset := (Form.CurrentEditor as TEditor).TextWidth(STYLE_DEFAULT,
      Copy(s, 1, DotOffset));
    if DotOffset > 1 then
      TmpOffset := TmpOffset + (3 * (DotOffset - 1))
  end
  else
    TmpOffset := 0;
  x := x - TmpOffset;

  ResetAssignedList;

  case Kind of
    ctCode:
      begin
        CurrentString := s;

        Form.FScrollbar.Visible := True;

        RecalcFormPlacement;

        // This may seem redundant, but it fixes scrolling bugs for the first time
        // up when MatchText is not true.  That is the only time these occur
        if not(scoLimitToMatchedText in Options) then
        begin
          Form.AdjustScrollBarPosition;
          Form.FScrollbar.Position := Form.Position;
        end;
        if Form.AssignedList.Count > 0 then
        begin
          ShowWindow(Form.Handle, SW_SHOWNOACTIVATE);
          Form.Visible := True;
        end;
      end;
    ctParams, ctHint:
      begin
        Form.FScrollbar.Visible := False;

        RecalcFormPlacement;

        ShowWindow(Form.Handle, SW_SHOWNOACTIVATE);
        Form.Visible := True;
        Form.Repaint;
      end;
  end;
end;

function TSynBaseCompletionProposal.GetCurrentString: string;
begin
  Result := Form.CurrentString;
end;

function TSynBaseCompletionProposal.GetItemList: TStrings;
begin
  Result := Form.ItemList;
end;

function TSynBaseCompletionProposal.GetInsertList: TStrings;
begin
  Result := Form.InsertList;
end;

function TSynBaseCompletionProposal.GetOnCancel: TNotifyEvent;
begin
  Result := Form.OnCancel;
end;

function TSynBaseCompletionProposal.GetOnKeyPress: TKeyPressEvent;
begin
  Result := Form.OnKeyPress;
end;

function TSynBaseCompletionProposal.GetOnPaintItem
  : TSynBaseCompletionProposalPaintItem;
begin
  Result := Form.OnPaintItem;
end;

function TSynBaseCompletionProposal.GetOnMeasureItem
  : TSynBaseCompletionProposalMeasureItem;
begin
  Result := Form.OnMeasureItem;
end;

function TSynBaseCompletionProposal.GetOnValidate: TValidateEvent;
begin
  Result := Form.OnValidate;
end;

function TSynBaseCompletionProposal.GetPosition: Integer;
begin
  Result := Form.Position;
end;

procedure TSynBaseCompletionProposal.SetCurrentString(const Value: string);
begin
  Form.CurrentString := Value;
end;

procedure TSynBaseCompletionProposal.SetItemList(const Value: TStrings);
begin
  Form.ItemList := Value;
end;

procedure TSynBaseCompletionProposal.SetInsertList(const Value: TStrings);
begin
  Form.InsertList := Value;
end;

procedure TSynBaseCompletionProposal.SetNbLinesInWindow(const Value: Integer);
begin
  FNbLinesInWindow := Value;
end;

procedure TSynBaseCompletionProposal.SetOnCancel(const Value: TNotifyEvent);
begin
  Form.OnCancel := Value;
end;

procedure TSynBaseCompletionProposal.SetOnKeyPress(const Value: TKeyPressEvent);
begin
  Form.OnKeyPress := Value;
end;

procedure TSynBaseCompletionProposal.SetOnPaintItem
  (const Value: TSynBaseCompletionProposalPaintItem);
begin
  Form.OnPaintItem := Value;
end;

procedure TSynBaseCompletionProposal.SetOnMeasureItem
  (const Value: TSynBaseCompletionProposalMeasureItem);
begin
  Form.OnMeasureItem := Value;
end;

procedure TSynBaseCompletionProposal.SetPosition(const Value: Integer);
begin
  Form.Position := Value;
end;

procedure TSynBaseCompletionProposal.SetOnValidate(const Value: TValidateEvent);
begin
  Form.OnValidate := Value;
end;

function TSynBaseCompletionProposal.GetClSelect: TColor;
begin
  Result := Form.ClSelect;
end;

procedure TSynBaseCompletionProposal.SetClSelect(const Value: TColor);
begin
  Form.ClSelect := Value;
end;

procedure TSynBaseCompletionProposal.SetWidth(Value: Integer);
begin
  FWidth := Value;
end;

procedure TSynBaseCompletionProposal.Activate;
begin
  if Assigned(Form) then
    Form.Activate;
end;

procedure TSynBaseCompletionProposal.Deactivate;
begin
  if Assigned(Form) then
    Form.Deactivate;
end;

function TSynBaseCompletionProposal.GetClBack: TColor;
begin
  Result := Form.ClBackground;
end;

procedure TSynBaseCompletionProposal.SetClBack(const Value: TColor);
begin
  Form.ClBackground := Value
end;

function TSynBaseCompletionProposal.GetClSelectedText: TColor;
begin
  Result := Form.ClSelectedText;
end;

procedure TSynBaseCompletionProposal.SetClSelectedText(const Value: TColor);
begin
  Form.ClSelectedText := Value;
end;

procedure TSynBaseCompletionProposal.AddItem(ADisplayText, AInsertText: string);
begin
  GetInsertList.Add(AInsertText);
  GetItemList.Add(ADisplayText);
end;

procedure TSynBaseCompletionProposal.AddItemAt(Where: Integer;
  ADisplayText, AInsertText: string);
begin
  try
    GetInsertList.Insert(Where, AInsertText);
    GetItemList.Insert(Where, ADisplayText);
  except
    raise Exception.Create('Cannot insert item at position ' + IntToStr(Where)
        + '.');
  end;
end;

procedure TSynBaseCompletionProposal.ClearList;
begin
  GetInsertList.Clear;
  GetItemList.Clear;
end;

function TSynBaseCompletionProposal.DisplayItem(AIndex: Integer): string;
begin
  Result := GetItemList[AIndex];
end;

function TSynBaseCompletionProposal.InsertItem(AIndex: Integer): string;
begin
  Result := GetInsertList[AIndex];
end;

function TSynBaseCompletionProposal.GetDisplayKind: SynCompletionType;
begin
  Result := Form.DisplayType;
end;

procedure TSynBaseCompletionProposal.SetDisplayKind
  (const Value: SynCompletionType);
begin
  Form.DisplayType := Value;
end;

function TSynBaseCompletionProposal.GetParameterToken: TCompletionParameter;
begin
  Result := Form.OnParameterToken;
end;

procedure TSynBaseCompletionProposal.SetParameterToken
  (const Value: TCompletionParameter);
begin
  Form.OnParameterToken := Value;
end;

procedure TSynBaseCompletionProposal.SetColumns(const Value: TProposalColumns);
begin
  FForm.Columns := Value;
end;

function TSynBaseCompletionProposal.GetColumns: TProposalColumns;
begin
  Result := FForm.Columns;
end;

function TSynBaseCompletionProposal.GetResizeable: Boolean;
begin
  Result := FForm.Resizeable;
end;

procedure TSynBaseCompletionProposal.SetResizeable(const Value: Boolean);
begin
  if FForm.Resizeable <> Value then
    FForm.Resizeable := Value;
end;

function TSynBaseCompletionProposal.GetItemHeight: Integer;
begin
  Result := FForm.ItemHeight;
end;

procedure TSynBaseCompletionProposal.SetItemHeight(const Value: Integer);
begin
  if FForm.ItemHeight <> Value then
    FForm.ItemHeight := Value;
end;

procedure TSynBaseCompletionProposal.SetImages(const Value: TImageList);
begin
  FForm.Images := Value;
end;

function TSynBaseCompletionProposal.GetImages: TImageList;
begin
  Result := FForm.Images;
end;

function TSynBaseCompletionProposal.GetMargin: Integer;
begin
  Result := FForm.Margin;
end;

procedure TSynBaseCompletionProposal.SetMargin(const Value: Integer);
begin
  if Value <> FForm.Margin then
    FForm.Margin := Value;
end;

function TSynBaseCompletionProposal.GetDefaultKind: SynCompletionType;
begin
  Result := Form.DefaultType;
end;

procedure TSynBaseCompletionProposal.SetDefaultKind
  (const Value: SynCompletionType);
begin
  Form.DefaultType := Value;
  Form.DisplayType := Value;
  Form.RecreateWnd;
end;

procedure TSynBaseCompletionProposal.SetEndOfTokenChar(const Value: string);
begin
  if Form.FEndOfTokenChr <> Value then
  begin
    Form.FEndOfTokenChr := Value;
  end;
end;

function TSynBaseCompletionProposal.GetClTitleBackground: TColor;
begin
  Result := Form.ClTitleBackground;
end;

procedure TSynBaseCompletionProposal.SetClTitleBackground(const Value: TColor);
begin
  Form.ClTitleBackground := Value;
end;

function TSynBaseCompletionProposal.GetTitle: string;
begin
  Result := Form.Title;
end;

procedure TSynBaseCompletionProposal.SetTitle(const Value: string);
begin
  Form.Title := Value;
end;

function TSynBaseCompletionProposal.GetFont: TFont;
begin
  Result := Form.Font;
end;

function TSynBaseCompletionProposal.GetTitleFont: TFont;
begin
  Result := Form.TitleFont;
end;

procedure TSynBaseCompletionProposal.SetFont(const Value: TFont);
begin
  Form.Font := Value;
end;

procedure TSynBaseCompletionProposal.SetTitleFont(const Value: TFont);
begin
  Form.TitleFont := Value;
end;

function TSynBaseCompletionProposal.GetEndOfTokenChar: string;
begin
  Result := Form.EndOfTokenChr;
end;

function TSynBaseCompletionProposal.GetOptions: TSynCompletionOptions;
begin
  Result := FOptions;
end;

procedure TSynBaseCompletionProposal.SetOptions
  (const Value: TSynCompletionOptions);
begin
  if FOptions <> Value then
  begin
    FOptions := Value;
    Form.CenterTitle := scoTitleIsCentered in Value;
    Form.AnsiStrings := scoAnsiStrings in Value;
    Form.CaseSensitive := scoCaseSensitive in Value;
    Form.UsePrettyText := scoUsePrettyText in Value;
    Form.UseInsertList := scoUseInsertList in Value;
    Form.MatchText := scoLimitToMatchedText in Value;
    Form.CompleteWithTab := scoCompleteWithTab in Value;
    Form.CompleteWithEnter := scoCompleteWithEnter in Value;
  end;
end;

function TSynBaseCompletionProposal.GetTriggerChars: string;
begin
  Result := Form.TriggerChars;
end;

procedure TSynBaseCompletionProposal.SetTriggerChars(const Value: string);
begin
  Form.TriggerChars := Value;
end;

procedure TSynBaseCompletionProposal.EditorCancelMode(Sender: TObject);
begin
  // Do nothing here, used in TCompletionProposal
end;

function TSynBaseCompletionProposal.GetOnChange: TCompletionChange;
begin
  Result := Form.FOnChangePosition;
end;

procedure TSynBaseCompletionProposal.SetOnChange
  (const Value: TCompletionChange);
begin
  Form.FOnChangePosition := Value;
end;

procedure TSynBaseCompletionProposal.ResetAssignedList;
begin
  Form.AssignedList.Assign(ItemList);
end;

{ ----------------  TCompletionProposal -------------- }

procedure TCompletionProposal.HandleOnCancel(Sender: TObject);
var
  F: TSynBaseCompletionProposalForm;
begin
  F := Sender as TSynBaseCompletionProposalForm;
  if F.CurrentEditor <> nil then
  begin
    if Assigned(FTimer) then
      FTimer.Enabled := False;
    F.Hide;
    GetParentForm(F.CurrentEditor).Show;
    if Assigned(OnCancelled) then
      OnCancelled(Self); // GBN 13/11/2001
  end;
end;

procedure TCompletionProposal.HandleOnValidate(Sender: TObject;
  Shift: TShiftState; var EndToken: Char);

  procedure CopyStringToCharSet(const AStr: AnsiString;
    var ACharSet: TSynIdentChars);
  var
    i: Integer;
  begin
    for i := 1 to Length(AStr) do
      Include(ACharSet, AStr[i]);
  end;

var
  F: TSynBaseCompletionProposalForm;
  Value: string;
  index: Integer; // GBN 15/11/2001
  // ## Falcon C++ Changes
  Handled: Boolean;
  WordEndPos, OffsetCaret: Integer;
  WordEndChars: TSynIdentChars;
  WordCharsStr, LineStr: string;
  // ## End Falcon C++ Changes
begin
  F := Sender as TSynBaseCompletionProposalForm;
  if Assigned(F.CurrentEditor) then
    with F.CurrentEditor as TEditor do
    begin
      // Treat entire completion as a single undo operation
      BeginUpdate;
      BeginUndoAction;
      try
        if FAdjustCompletionStart then
          FCompletionStart := BufferCoord(FCompletionStart, CaretY).Char;
        BlockBegin := BufferCoord(FCompletionStart, CaretY);
        if EndToken = #0 then
        // ## Falcon C++ Changes
        begin
          Handled := False;
          WordCharsStr := '';
          if Assigned(OnGetWordEndChars) then
            OnGetWordEndChars(Self, WordCharsStr,
              F.LogicalToPhysicalIndex(Position), Handled);
          if not Handled then
            BlockEnd := BufferCoord(WordEnd.Char, CaretY)
          else
          begin
            LineStr := '';
            WordEndChars := [];
            CopyStringToCharSet(AnsiString(WordCharsStr), WordEndChars);
            if CaretY <= Lines.Count then
              LineStr := Lines.Strings[CaretY - 1];
            WordEndPos := WordEnd.Char;
            while WordEndPos < Length(LineStr) do
            begin
              if ((Form.FScanChars = []) and not CharInSet(LineStr[WordEndPos],
                  DefaulTSynIdentChars)) or CharInSet(LineStr[WordEndPos],
                Form.FScanChars) then
              begin
                inc(WordEndPos);
                break;
              end;
              inc(WordEndPos);
            end;
            BlockEnd := BufferCoord(WordEndPos, CaretY);
          end;
        end
        // ## End Falcon C++ Changes
        else
          BlockEnd := BufferCoord(CaretX, CaretY);

        if scoUseInsertList in FOptions then
        begin
          if scoLimitToMatchedText in FOptions then
          begin
            if (Form.FAssignedList.Count > Position) then
              // GBN 15/01/2002 - Added check to make sure item is only used when no EndChar
              if (InsertList.Count > Integer
                  (Form.FAssignedList.Objects[Position])) and
                ((scoEndCharCompletion in FOptions) or (EndToken = #0)) then
                Value := InsertList
                  [Integer(Form.FAssignedList.Objects[Position])]
              else
                Value := SelText
              else
                Value := SelText;
          end
          else
          begin
            // GBN 15/01/2002 - Added check to make sure item is only used when no EndChar
            if (InsertList.Count > Position) and
              ((scoEndCharCompletion in FOptions) or (EndToken = #0)) then
              Value := InsertList[Position]
            else
              Value := SelText;
          end;
        end
        else
        begin
          // GBN 15/01/2002 - Added check to make sure item is only used when no EndChar
          if (Form.FAssignedList.Count > Position) and
            ((scoEndCharCompletion in FOptions) or (EndToken = #0)) then
            Value := Form.FAssignedList[Position]
          else
            Value := SelText;
        end;
        index := Position; // GBN 15/11/2001, need to assign position to temp var since it changes later

        OffsetCaret := 0;
        // GBN 15/01/2002 - Cleaned this code up a bit
        if Assigned(FOnCodeCompletion) then
          FOnCodeCompletion(Self, Value, Shift,
            F.LogicalToPhysicalIndex(index), EndToken, OffsetCaret);
        // GBN 15/11/2001

        if SelText <> Value then
          SelText := Value;
        with (F.CurrentEditor as TEditor) do
        begin
          // GBN 25/02/2002
          // This replaces the previous way of cancelling the completion by
          // sending a WM_MOUSEDOWN message. The problem with the mouse down is
          // that the editor would bounce back to the left margin, very irritating
          InternalCancelCompletion;
          CaretXY := BlockEnd;
          if OffsetCaret <> 0 then
            SetCurrentPos(GetCurrentPos + OffsetCaret);
          BlockBegin := CaretXY;
        end;
        // GBN 15/11/2001
        if Assigned(FOnAfterCodeCompletion) then
          FOnAfterCodeCompletion(Self, Value, Shift,
            F.LogicalToPhysicalIndex(index), EndToken);

      finally
        EndUndoAction;
        EndUpdate;
      end;
    end;
end;

procedure TCompletionProposal.HandleOnKeyPress(Sender: TObject; var Key: Char);
var
  F: TSynBaseCompletionProposalForm;
begin
  F := Sender as TSynBaseCompletionProposalForm;
  if F.CurrentEditor <> nil then
  begin
    // GBN 22/11/2001
    // Daisy chain completions
    Application.ProcessMessages;
    if (System.Pos(Key, TriggerChars) > 0) and not F.Visible then
    begin
      // GBN 18/02/2002
      if (Sender is TEditor) then
        DoExecute(Sender as TEditor)
      else if Assigned(Form.CurrentEditor) then
        DoExecute(Form.CurrentEditor as TEditor);
    end;
  end;
end;

constructor TCompletionProposal.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Form.OnKeyPress := HandleOnKeyPress;
  Form.OnValidate := HandleOnValidate;
  Form.OnCancel := HandleOnCancel;
  Form.OnDblClick := HandleDblClick;
  EndOfTokenChr := DefaultEndOfTokenChr;
  TriggerChars := '.';
  FTimerInterval := 1000;

  FShortCut := Menus.ShortCut(Ord(' '), [ssCtrl]);
  Options := DefaultProposalOptions;
end;

procedure TCompletionProposal.SetShortCut(Value: TShortCut);
begin
  FShortCut := Value;
end;

procedure TCompletionProposal.EditorKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  ShortCutKey: Word;
  ShortCutShift: TShiftState;
begin
  ShortCutToKey(FShortCut, ShortCutKey, ShortCutShift);
  with Sender as TEditor do
  begin
    if Executing then
    begin
      FForm.KeyDown(Key, Shift);
    end
    else if ((DefaultType <> ctCode) or not(readonly)) and
      (Shift = ShortCutShift) and (Key = ShortCutKey) then
    begin
      Form.CurrentEditor := Sender as TEditor;
      DoExecute(Sender as TEditor);
    end;
  end;
end;

procedure TCompletionProposal.EditorKeyPress(Sender: TObject; var Key: Char);
begin
  if Executing then
  begin
    if Key <> #0 then
      FForm.KeyPress(Key);
  end
  else if Assigned(FTimer) then
  begin
    if (Pos(Key, TriggerChars) <> 0) then
      ActivateTimer(Sender as TEditor)
    else
      DeactivateTimer;
  end;
end;

function TCompletionProposal.GetCurrentInput(AEditor: TEditor): string;
var
  s: string;
  i: Integer;
begin
  Result := '';
  if AEditor <> nil then
  begin
    s := AEditor.LineText;
    i := AEditor.CaretX - 1;
    if i <= Length(s) then
    begin
      FAdjustCompletionStart := False;
      while (i > 0) and (s[i] > #32) and not
        (((Form.FScanChars = []) and not CharInSet(s[i],
            DefaulTSynIdentChars)) or CharInSet(s[i],
          Form.FScanChars)) do
        Dec(i);

      FCompletionStart := i + 1;
      Result := Copy(s, i + 1, AEditor.CaretX - i - 1);
    end
    else
      FAdjustCompletionStart := True;

    FCompletionStart := i + 1;
  end;
end;

function TCompletionProposal.GetPreviousToken(AEditor: TEditor): string;
var
  Line: string;
  x: Integer;
  BreakChars: TSynIdentChars;
begin
  Result := '';
  if not Assigned(AEditor) then
    exit;

  Line := AEditor.Lines[AEditor.CaretXY.Line - 1];
  x := AEditor.CaretXY.Char - 1;
  if (x = 0) or (x > Length(Line)) or (Length(Line) = 0) then
    exit;

  BreakChars := Form.FScanChars;
  if CharInSet(Line[x], BreakChars) then
    Dec(x);

  BreakChars := BreakChars + [#9, #32];

  while (x > 0) and not(((Form.FScanChars = []) and not CharInSet(Line[x],
        DefaulTSynIdentChars)) or CharInSet(Line[x], BreakChars)) do
  begin
    Result := Line[x] + Result;
    Dec(x);
  end;
end;

procedure TCompletionProposal.ActivateTimer(ACurrentEditor: TEditor);
begin
  if Assigned(FTimer) then
  begin
    Form.CurrentEditor := ACurrentEditor;
    FTimer.Enabled := True;
  end;
end;

procedure TCompletionProposal.DeactivateTimer;
begin
  if Assigned(FTimer) then
  begin
    FTimer.Enabled := False;
  end;
end;

procedure TCompletionProposal.HandleDblClick(Sender: TObject);
var
  C: Char;
  P: TPoint;
  i: Integer;
begin
  P := FForm.ScreenToClient(Mouse.CursorPos);
  i := FForm.ItemIndexAt(P);
  if i < 0 then
    exit;
  C := #0;
  HandleOnValidate(Sender, [], C);
end;

destructor TCompletionProposal.Destroy;
begin
  if Form.Visible then
    CancelCompletion;
  inherited;
end;

procedure TCompletionProposal.TimerExecute(Sender: TObject);
begin
  if not Assigned(FTimer) then
    exit;
  FTimer.Enabled := False; // GBN 13/11/2001
  if Application.Active then
  begin
    DoExecute(Form.CurrentEditor as TEditor);
  end
  else if Form.Visible then
    Form.Hide;
end;

function TCompletionProposal.GetTimerInterval: Integer;
begin
  Result := FTimerInterval;
end;

procedure TCompletionProposal.SetTimerInterval(const Value: Integer);
begin
  FTimerInterval := Value;
  if Assigned(FTimer) then
    FTimer.Interval := Value;
end;

procedure TCompletionProposal.SetOptions(const Value: TSynCompletionOptions);
begin
  inherited;

  if scoUseBuiltInTimer in Value then
  begin
    if not(Assigned(FTimer)) then
    begin
      FTimer := TTimer.Create(Self);
      FTimer.Enabled := False;
      FTimer.Interval := FTimerInterval;
      FTimer.OnTimer := TimerExecute;
    end;
  end
  else
  begin
    if Assigned(FTimer) then
    begin
      FreeAndNil(FTimer);
    end;
  end;

end;

procedure TCompletionProposal.ExecuteEx(s: string; x, y: Integer;
  Kind: SynCompletionType);
begin
  inherited;
  if Assigned(FTimer) then
    FTimer.Enabled := False;
end;

procedure TCompletionProposal.DoExecute(AEditor: TEditor);

  procedure CopyStringToCharSet(const AStr: AnsiString;
    var ACharSet: TSynIdentChars);
  var
    i: Integer;
  begin
    for i := 1 to Length(AStr) do
      Include(ACharSet, AStr[i]);
  end;

  procedure CopyWordBreakCharsToCharSet(const AEditor: TEditor;
    var ACharSet: TSynIdentChars);
  begin
    ACharSet := ACharSet + TSynWordBreakChars;
  end;

var
  P: TPoint;
  // ##Falcon C++ Changes
  cInput, cScan: string;
  // ##End Falcon C++ Changes
begin
  with AEditor do
  begin
    if (DefaultType <> ctCode) or not(readonly) then
    begin
      if DefaultType = ctHint then
        GetCursorPos(P)
      else
      begin
        P := ClientToScreen(RowColumnToPixels(DisplayXY));
        inc(P.y, LineHeight);
      end;
      Form.CurrentEditor := AEditor;
      Form.FWordBreakChars := [];
      Form.FScanChars := [];
      // ##Falcon C++ Changes
      if Assigned(OnGetWordBreakChars) then
      begin
        OnGetWordBreakChars(Self, cInput, cScan);
        CopyStringToCharSet(AnsiString(cInput), Form.FWordBreakChars);
        CopyStringToCharSet(AnsiString(cScan), Form.FScanChars);
      end
      else
      begin
        if scoConsiderWordBreakChars in Self.Options then
          CopyWordBreakCharsToCharSet(Form.CurrentEditor as TEditor,
            Form.FWordBreakChars);

        CopyStringToCharSet(AnsiString(EndOfTokenChr), Form.FWordBreakChars);
        CopyStringToCharSet(AnsiString(EndOfTokenChr), Form.FScanChars);
      end;
      // ##End Falcon C++ Changes
      FPreviousToken := GetPreviousToken(Form.CurrentEditor as TEditor);
      ExecuteEx(GetCurrentInput(AEditor), P.x, P.y, DefaultType);
    end;
  end;
end;

// 25/02/2002 GBN
procedure TCompletionProposal.InternalCancelCompletion;
begin
  if Assigned(FTimer) then
    FTimer.Enabled := False;
  if (Form.Visible) then
  begin
    Deactivate;
    Form.Hide;
  end;
end;

procedure TCompletionProposal.CancelCompletion;
begin
  InternalCancelCompletion; // 25/02/2002 GBN
  if Assigned(OnCancelled) then
    OnCancelled(Self); // GBN 13/11/2001
end;

function TCompletionProposal.GetExecuting: Boolean;
begin
  Result := Form.Visible;
end;

// GBN 13/11/2001
procedure TCompletionProposal.EditorCancelMode(Sender: TObject);
begin
  if (DisplayType = ctParams) then
    CancelCompletion;
end;

procedure TCompletionProposal.ActivateCompletion(Editor: TEditor);
begin
  DoExecute(Editor);
end;

end.
