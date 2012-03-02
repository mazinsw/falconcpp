unit ULanguages;

interface

uses
  Windows, SysUtils, Classes, Dialogs, ComCtrls, Controls,
  IniFiles, ImgList;

const
  APS = '''';
  
  MAX_MENUS = 8;
  CONST_STR_MENUS: array[1..MAX_MENUS] of String = (
  //Top Menu
    '&File',
    '&Edit',
    '&Search',
    '&View',
    '&Project',
    '&Run',
    '&Tools',
    '&Help'
  );

  MAX_MENU_FILE = 18;
  CONST_STR_MENU_FILE: array[1..MAX_MENU_FILE] of String = (
  //File Menu
    '&New',
    '&Open...',
    '&Reopen',
    '',
    '&Save',
    'Save &As...',
    'Save All',
    '',
    'Import',
    'Export',
    '',
    '&Close',
    'C&lose All',
    'Re&move',
    '',
    '&Print',
    '',
    '&Exit'
  );
  MAX_MENU_EDIT = 19;
  CONST_STR_MENU_EDIT: array[1..MAX_MENU_EDIT] of String = (
  //Edit Menu
    'Undo',
    'Redo',
    '',
    'Cut',
    'Copy',
    'Paste',
    '',
    'Swap header/source',
    '',
    'Delete',
    'Select All',
    '',
    'Toggle Bookmarks',
    'Goto Bookmarks',
    '',
    'Indent',
    'Unindent',
    '',
    'Format'
  );

  MAX_MENU_SERH = 11;
  CONST_STR_MENU_SERH: array[1..MAX_MENU_SERH] of String  = (
  //Search Menu
    'Find...',
    'Find Next',
    'Find Previous',
    'Find in Files...',
    'Replace...',
    'Incremental Search...',
    '',
    'Goto Funcion...',
    'Goto Previous Function',
    'Goto Next Function',
    'Goto Line Number...'
  );

  MAX_MENU_VIEW = 11;
  CONST_STR_MENU_VIEW: array[1..MAX_MENU_VIEW] of String  = (
  //View Menu
    'Project Manager',
    'Statusbar',
    'Outline',
    'Compiler Output',
    'Toolbars',
    'Themes',
    'Zoom',
    '',
    'Full Screen',
    '',
    'Restore Default'
  );

  MAX_MENU_PROJ = 6;
  CONST_STR_MENU_PROJ: array[1..MAX_MENU_PROJ] of String = (
  //Project Menu
    'Add...',
    'Remove...',
    '',
    'Build',
    '',
    'Properties...'
  );

  MAX_MENU_RUN = 10;
  CONST_STR_MENU_RUN : array[1..MAX_MENU_RUN] of String = (
  //Run Menu
    'Run',
    'Compile',
    'Execute',
    '',
    'Toggle Breakpoint',
    'Step Into',
    'Step Over',
    'Step Return',
    'Run to Cursor',
    'Stop'
  );

  MAX_MENU_TOOL = 8;
  CONST_STR_MENU_TOOL: array[1..MAX_MENU_TOOL] of String = (
  //Tools Menu
    'Environment Options...',
    'Compiler Options',
    'Editor Options...',
    '',
    'Template Creator...',
    'Package Creator...',
    '',
    'Packages'
  );

  MAX_MENU_HELP = 7;
  CONST_STR_MENU_HELP: array[1..MAX_MENU_HELP] of String = (
  //Help Menu
    'Falcon Help',
    'Tip of the Day...',
    '',
    'Update',
    'Report a Bug/Comment',
    '',
    'About...'
  );

  MAX_NEW_MENU = 8;
  CONST_STR_NEW_MENU: array[1..MAX_NEW_MENU] of String  = (
  //New From Menu File
    '&Project...',
    'C File',
    'C++ File',
    'Header File',
    'Resource File',
    'Empty File',
    '',
    'Folder'
  );

  MAX_VIEWTOOLBAR_MENU = 8;
  CONST_STR_VIEWTOOLBAR_MENU: array[1..MAX_VIEWTOOLBAR_MENU] of String = (
    'Default Bar',
    'Edit Bar',
    'Search Bar',
    'Compiler Bar',
    'Navigator Bar',
    'Project Bar',
    'Help Bar',
    'Debug Bar'
  );

  MAX_DEFAULTBAR = 6;
  CONST_STR_DEFAULTBAR: array[1..MAX_DEFAULTBAR] of String = (
  //DefaultBar
    'New',
    'Open',
    'Remove',
    '',
    'Save',
    'Save All'
  );

  MAX_EDITBAR = 2;
  CONST_STR_EDITBAR: array[1..MAX_EDITBAR] of String = (
  //EditBar
    'Undo',
    'Redo'
  );

  MAX_NAVIGATORBAR = 5;
  CONST_STR_NAVIGATORBAR: array[1..MAX_NAVIGATORBAR] of String = (
  //NavigatorBar
    'Previous Page',
    'Next Page',
    '',
    'Toggle Bookmarks',
    'Goto Bookmarks'
  );

  MAX_COMPILERBAR = 5;
  CONST_STR_COMPILERBAR: array[1..MAX_COMPILERBAR] of String = (
  //CompilerBar
    'Run',
    'Compile',
    'Execute',
    '',
    'Stop'
  );

  MAX_HELPBAR = 2;
  CONST_STR_HELPBAR: array[1..MAX_HELPBAR] of String = (
  //HelpBar
    'Help',
    'Context Help'
  );

  MAX_PROJECTBAR = 2;
  CONST_STR_PROJECTBAR: array[1..MAX_PROJECTBAR] of String = (
  //ProjectBar
    'New Project',
    'Properties'
  );

  MAX_DEBUGBAR = 3;
  CONST_STR_DEBUGBAR: array[1..MAX_DEBUGBAR] of String = (
  //DebugBar
    'Step Into',
    'Step Over',
    'Step Return'
  );

  MAX_SEARCHBAR = 4;
  CONST_STR_SEARCHBAR: array[1..MAX_SEARCHBAR] of String = (
  //SearchBar
    'Find',
    'Replace',
    '',
    'Goto Line Number'
  );

  MAX_POPUP_PROJ = 11;
  CONST_STR_POPUP_PROJ: array[1..MAX_POPUP_PROJ] of String  = (
  //PopupMenu from Project List
    '&New',
    '',
    'Edit',
    'Open',
    '',
    'Add to project',
    'Remove',
    'Rename',
    'Delete from disk',
    '',
    'Property...'
  );

  MAX_POPUP_EDITOR = 20;
  CONST_STR_POPUP_EDITOR: array[1..MAX_POPUP_EDITOR] of String  = (
  //PopupMenu from Editor
    'Open declaration',
    '',
    'Complete class at cursor',
    'Swap header/source',
    '',
    'Undo',
    'Redo',
    '',
    'Cut',
    'Copy',
    'Paste',
    'Delete',
    'Select All',
    '',
    'Tools',
    '',
    'Toggle Bookmarks',
    'Goto Bookmarks',
    '',
    'Properties...'
  );

  MAX_POPUP_TABS = 13;
  CONST_STR_POPUP_TABS: array[1..MAX_POPUP_TABS] of String  = (
  //PopupMenu from PageControl
    '&Close',
    'Close &all',
    'Close all others',
    '',
    'Save',
    'Save all',
    '',
    'Swap header/source',
    '',
    'Tabs at top',
    'Tabs at bottom',
    '',
    'Properties...'
  );
  
  MAX_FRM_MAIN = 45;
  CONST_STR_FRM_MAIN: array[1..MAX_FRM_MAIN] of String  = (
    //Tabs Left
    'Projects',
    'Explorer',
    //Tabs Right
    'Outline',
    //Tabs Down
    'Messages',
    'Chat',
    //Messages List
    'File',
    'Line',
    'Notification',
    //Others
    'Empty project',
    'Save changes to "%s"?',
    'Falcon project file',
    'All types',
    'NewFile',
    'NewFolder',
    'main',
    'resource',
    'Running',
    'Compiling',
    'Building',
    'Delete file "%s" from project?',
    'Delete "%s" from disk?',
    'Generic error',
    'Project',
    'Translated by: %s',
    'Creating standard templates...',
    'Loading Templates...',
    'Loading Projects...',
    'Creating standard tools...',
    'Setting Environment Variable...',
    'Preparing to Launch Application...',
    '(Empty)',
    'Clear History',
    'Loading History...',
    'File %s not found',
    'All known files',
    'Loading all installed packages...',
    'Checking for new installed packages...',
    'dddd, d of mmmm of yyyy t',
    'Compilation sucess in %s seconds',
    'Compilation failed',
    'Adding messages %d/%d',
    'Parsing results %d/%d',
    'Do you want to create it?',
    'Debugging',
    'Loading configurations...'
  );

  MAX_FRM_PROP = 69;
  CONST_STR_FRM_PROP: array[1..MAX_FRM_PROP] of String  = (
    //Properties Form
    'Application',
    'Version Info',
    'Compiler',
    'Run',
    //Sheet Application
    'Application settings',
    'Project name:',
    'Tarjet:',
    'Icon:',
    'Double click to change application icon',
    'Load Icon...',
    'Output settings',
    'Target file extension:',
    'Includes all files into project',
    //Btns
    '&Ok',
    '&Cancel',
    'Apply',
    //Sheet Version info
    'Include version information in project',
    'Version numbers',
    'Major version',
    'Minor version',
    'Release',
    'Build',
    //150 at here
    'Auto increment build number',
    'Language',
    'Locale:',
    'Key',
    'Value',
    //Sheet Compiler
    'Compiler Type',
    'Optmizations',
    'Minimize Size',
    'Show Warnings',
    'Optimize speed',
    'Libraries',
    'Add',
    'Delete selected',
    'Move to up',
    'Move to Down',
    'Includes',
    'Cleaning',
    'Delete objects before compilation',
    'Delete objects after compilation',
    'Delete makefile after compilation',
    'Delete resources after compilation',
    //Sheet Run
    'Application',
    'Params:',
    'Properties',
    'Application Type',
    'Application Console',
    'Windows Application',
    'Dinamic Link Library',
    'Static Library',
    'Enable theme',
    'Requires admin level',
    'Create linked library',
    //Sheet Network
    'Network',
    'Network programming (not implemented)',
    'Type',
    'Server',
    'Client',
    'Client options',
    'Port',
    'Auto reconnect',
    'Authentication',
    'User',
    'Password',
    'Server options',
    'Disconnect',
    'Connect',
    'Select folder to include'
  );

  MAX_FRM_NEW_PROJ = 12;
  CONST_STR_FRM_NEW_PROJ: array[1..MAX_FRM_NEW_PROJ] of String  = (
    //New Project Form
    'New Project',
    '< Back',
    'Next >',
    'Finish',
    //FraProjs
    'Description',
    'Falcon C++ Project Wizard',
    //FraPrjOpt
    'Change',
    'Application Icon',
    'Company',
    'Version',
    'Product Name',
    'Name'
  );

  MAX_FRM_FIND = 33;
  CONST_STR_FRM_FIND: array[1..MAX_FRM_FIND] of String  = (
    //New Project Form
    'Find and replace',
    '&Find',
    '&Replace',
    'Fin&d in files',
    'Find:',
    'Replace with:',
    'Replace',
    'In selection',
    'Replace All',
    'More',
    'Less',
    'Find Next',
    'Cancel',
    'Search options',
    'Match &case',
    'Match whole &word only',
    'Wrap aroun&d',
    'Search mode',
    'Normal',
    'Extended (\n, \r, \t, \0, \x...)',
    'Regular expression',
    'Direction',
    'Up',
    'Down',
    'Transparency',
    'Opacity',
    'Search in',
    'Project',
    'Selected object',
    'Can''t find the text:'#13'"%s"',
    '%d occurrences were replaced.',
    'Stop',
    'Find ''%s'' in file ''%s'''
  );

  //Translate mingw messages  ' = 
  MAX_CMPMSG = 139;
  CONST_STR_CMPMSG: array[1..MAX_CMPMSG] of String = (
    '%s: In function ''%s'':',
    '%s:%d: warning: implicit declaration of function ''%s''',
    '%s:%d: warning: assignment makes pointer from integer without a cast',
    '%s:%d:%d: error: invalid suffix "%s" on integer constant',
    '%s:%d: warning: unused variable ''%s''',
    '%s:%d: error: ''%s'' was not declared in this scope',
    '%s:%d: error: expected ''%s'' before ''%s',
    '%s:%d:%d: error: macro "%s" passed %d arguments, but takes just %d',
    '%s:%d:%d: error: macro "%s" requires %d arguments, but only %d given',
    '%s:%d: error: at this point in file',
    '%s:%d: error: too many arguments to function ''%s''',
    '%s:%d: error: ''%s'' undeclared (first use in this function)',
    '%s:%d: error: expected ''%s'' before numeric constant',
    '%s:%d: error: (Each undeclared identifier is reported only once for each function it appears in.)',
    '%s:%d: warning: statement has no effect',
    '%s:%d: warning: passing argument %d of ''%s'' makes integer from pointer without a cast',
    '%s:%d: note: expected ''%s'' but argument is of type ''%s''',
    '%s:%d: error: invalid conversion from ''%s'' to ''%s''',
    '%s:%d: error:   initializing argument %d of ''%s''',
    '%s:%d: error: too few arguments to function ''%s''',
    '%s:%s:%s: undefined reference to `%s''',
    '%s:%d: error: cannot convert ''%s'' to ''%s'' for argument ''%s'' to ''%s''',
    '%s:%d: warning: value computed is not used',
    '%s:%d: warning: ''%s'' is used uninitialized in this function',
    '%s:%d: error: base operand of ''%s'' has non-pointer type ''%s''',
    '%s:%d:%d: error: %s: No such file or directory',
    '%s:%d: error: ''%s'' does not name a type',
    '%s:%d: error: expected initializer before ''%s''',
    '%s:%d: error: a function-definition is not allowed here before ''%s'' token expected ''%s'' at end of input',
    '%s:%d: warning: return makes integer from pointer without a cast',
    '%s:%d: warning: overflow in implicit constant conversion',
    '%s:%d: warning: integer constant is too large for ''%s'' type',
    '%s:%d:%d: warning: integer constant is too large for its type',
    '%s:%d: warning: this decimal constant is unsigned only in ISO C90',
    '%s:%d: error: expected ''%s'' before ''%s'' token',
    '%s:%d: error: expected expression before ''%s'' token',
    '%s:%d: note: ''%s'' was declared here',
    '%s:%d: warning: statement with no effect',
    '%s:%d: error: lvalue required as left operand of assignment',
    '%s:%d: warning: type defaults to ''%s'' in declaration of ''%s''',
    '%s:%d: warning: initialization makes integer from pointer without a cast',
    '%s:%d:%d: warning: character constant too long for its type',
    '%s:%d: error: expected identifier or ''%s'' before numeric constant',
    '%s:%d: error: expected ''='', '','', '';'', ''asm'' or ''__attribute__'' before ''%s''',
    '%s:%d: warning: label ''%s'' defined but not used',
    '%s:%d: error: ''%s'' has no member named ''%s''',
    '%s:%d: error: array subscript is not an integer',
    '%s:%d: warning: too few arguments for format',
    '%s:%d: warning: format ''%s'' expects type ''%s'', but argument %d has type ''%s''',
    '%s:%d: error: switch quantity not an integer',
    '%s:%d: error: incompatible type for argument %d of ''%s''',
    '%s:%d: error: expected statement before ''%s'' token',
    '%s:%d: warning: control reaches end of non-void function',
    '%s:%d: warning: ''%s'' may be used uninitialized in this function',
    '%s:%d: warning: missing braces around initializer',
    '%s:%d: warning: (near initialization for ''%s'')',
    '%s:%d: warning: statement is a reference, not call, to function ''%s''',
    '%s:%d: error: case label ''%s'' not within a switch statement',
    '%s:%d: error: expected primary-expression before ''%s'' token',
    '%s:%d: warning: no return statement in function returning non-void',
    '%s:%d: error: expected unqualified-id before ''%s''',
    '%s:%d: warning: array subscript is above array bounds',
    '%s:%d: warning: suggest parentheses around assignment used as truth value',
    '%s:%d: error: storage size of ''%s'' isn''t known',
    '%s:%d: error: invalid application of ''%s'' to incomplete type ''%s'' ',
    '%s:%d: warning: incompatible implicit declaration of built-in function ''%s''',
    '%s:%d: warning: comparison between signed and unsigned integer expressions',
    '%s:%d: warning: deprecated conversion from string constant to ''%s''',
    '%s:%d: error: expected class-name before ''%s'' token',
    '%s:%d: error: ISO C++ forbids declaration of ''%s'' with no type',
    '%s:%s: error: typedef ''%s'' is initialized (use decltype instead)',
    '%s:%d: error: expected constructor, destructor, or type conversion before ''%s'' token',
    '%s:%d: error: expected initializer before ''%s'' token',
    '%s:%d: error: expected constructor, destructor, or type conversion before ''%s''',
    'In file included from %s:%d:',
    '%s:%s:(%s): first defined here',
    '%s:%d: warning: enumeration value ''%s'' not handled in switch',
    '%s: In member function ''%s'':',
    '%s:%d: error: stray ''%s'' in program',
    '%s:%d: error: expected ''%s'' at end of input',
    '%s:%d: warning: field width should have type ''%s'', but argument %d has type ''%s''',
    '%s:%d: error: subscripted value is neither array nor pointer',
    '%s:%d: error: array type has incomplete element type',
    '%s:%d: warning: too many arguments for format',
    '%s:%d: warning: operation on ''%s'' may be undefined',
    '%s:%d:%d: error: unterminated comment',
    '%s:%d:%d: warning: "%s" within comment',
    '%s:%d:%d: warning: missing terminating %s character',
    '%s: %s: No such file or directory',
    '%s:%d: error: missing terminating %s character',
    '%s:%d: error: array size missing in ''%s''',
    '%s:%d: warning: passing argument %d of ''%s'' from incompatible pointer type',
    '%s:%d: warning: return type defaults to ''%s''',
    '%s:%d: error: expected identifier or ''%s'' before ''%s'' token',
    '%s:%d: error: expected identifier or ''%s'' at end of input',
    '%s:%d: error: expected specifier-qualifier-list before ''%s''',
    '%s:%d: warning: declaration does not declare anything',
    '%s:%d: error: bit-field ''%s'' width not an integer constant',
    '%s:%d: error: ''%s'' undeclared here (not in a function)',
    '%s: warning: ''%s'' after last input file has no effect',
    '%s: no input files',
    '%s: preprocessing failed.',
    '%s:%d: error: zero width for bit-field ''%s''',
    '%s:%d: error: width of ''%s'' exceeds its type',
    '%s:%d: warning: braces around scalar initializer',
    '%s:%d: warning: initialization from incompatible pointer type',
    '%s:%d: warning: excess elements in scalar initializer',
    '%s:%d: warning: left-hand operand of comma expression has no effect',
    '%s:%d: warning: assignment from incompatible pointer type',
    '%s:%d: warning: initializer-string for array of chars is too long',
    // 10/10/2011
    '%s: no resources',
    '%s:%d: error: invalid application of ''%s'' to incomplete type ''%s''',
    '%s:%d: error: void value not ignored as it ought to be',
    'Creating library file: %s',
    '%s:%d: warning: useless type name in empty declaration',
    '%s:%d: warning: unknown conversion type character ''%s'' in format',
    '%s:%d: error: parameter name omitted',
    '%s:%d: error: expected declaration specifiers before ''%s''',
    '%s:%d: error: old-style parameter declarations in prototyped function definition',
    '%s:%d: warning: empty declaration',
    '%s:%d: error: expected declaration specifiers before ''%s'' token',
    '%s:%d: error: expected declaration specifiers or ''%s'' before ''%s''',
    '%s:%d: error: storage class specified for parameter ''%s''',
    '%s:%d: error: duplicate member ''%s''',
    '%s:%d: error: expected ''%s'' before string constant',
    '%s:%d: error: called object ''%s'' is not a function',
    '%s:%d: Error: too many memory references for `%s''',
    '%s:%d: warning: excess elements in array initializer',
    '%s:%d: error: size of array ''%s'' is too large',
    '%s:%d: error: incompatible types when assigning to type ''%s'' from type ''%s''',
    '%s:%d: error: invalid operands to binary %s (have ''%s'' and ''%s'')',
    '%s:%d: warning: assuming signed overflow does not occur when assuming that %s is always %s',
    '%s:%s:(%s): more undefined references to `%s'' follow',
    '%s:%d: warning: extended initializer lists only available with %s or %s',
    '%s:%d: error: type of formal parameter %d is incomplete',
    '%s:%d: warning: dereferencing ''%s'' pointer',
    '%s:%d: error: request for member ''%s'' in something not a structure or union',
    '%s:%d: error: conflicting types for ''%s''',
    '%s:%d: note: previous definition of ''%s'' was here'
  );

  MAX_FRM_UPD = 25;
  CONST_STR_FRM_UPD: array[1..MAX_FRM_UPD] of String = (
    'Application Update',
    'Looking for updates',
    '&Update',
    'Falcon C++ is open, close it!',
    'Update failed',
    'Conection problem.',
    'Upgrade completed successfully.',
    'Upgrade completed',
    'Download failed: try again.',
    'Download error',
    'Downloading 0%...',
    'Connecting...',
    'Downloading...',
    'Locating new version of the Falcon C++...',
    'Changes:',
    'XML Format error',
    'No update available',
    'This version is newer than the repository',
    'Installed version is already the newest version',
    'Update available',
    'New version available: %s',
    '&Close',
    '&Ok',
    '&Cancel',
    'Installing...'
  );

type
  TLanguageProperty = class
    ID: Cardinal;
    Name: String;
    ImageIndex: TImageIndex;
    Version: String;
    Translator: String;
    Email: String;
  end;

  TFalconLanguages = class
  private
    FList: TStrings;
    FDefault: Boolean;
    FLangDir: String;
    FCurrent: TLanguageProperty;
    procedure SetLangDefault(Value: Boolean);
    function GetItem(Index: Integer): TLanguageProperty;
    function GetCount: Integer;
    procedure UpdateForms;
    procedure Clear;
  public
    function Load: Boolean;
    constructor Create;
    destructor Destroy; override;
    function UpdateLang(LangName: String): Boolean;
    function GetLangByID(LangID: Word): String;
    function GetImageIndexByID(LangID: Word): Integer;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TLanguageProperty read GetItem;
  published
    property LangDir: String read FLangDir write FLangDir;
    property LangDefault: Boolean read FDefault write SetLangDefault;
    property Current: TLanguageProperty read FCurrent write FCurrent;
  end;

var
  //STR_OTHERS: array[1..300] of String;

  STR_MENUS: array[1..MAX_MENUS] of String;
  STR_MENU_FILE: array[1..MAX_MENU_FILE] of String;
  STR_MENU_EDIT: array[1..MAX_MENU_EDIT] of String;
  STR_MENU_SERH: array[1..MAX_MENU_SERH] of String;
  STR_MENU_VIEW: array[1..MAX_MENU_VIEW] of String;
  STR_MENU_PROJ: array[1..MAX_MENU_PROJ] of String;
  STR_MENU_RUN : array[1..MAX_MENU_RUN] of String;
  STR_MENU_TOOL: array[1..MAX_MENU_TOOL] of String;
  STR_MENU_HELP: array[1..MAX_MENU_HELP] of String;
  STR_NEW_MENU: array[1..MAX_NEW_MENU] of String;
  STR_VIEWTOOLBAR_MENU: array[1..MAX_VIEWTOOLBAR_MENU] of String;

  STR_DEFAULTBAR: array[1..MAX_DEFAULTBAR] of String;
  STR_EDITBAR: array[1..MAX_EDITBAR] of String;
  STR_SEARCHBAR: array[1..MAX_SEARCHBAR] of String;
  STR_COMPILERBAR: array[1..MAX_COMPILERBAR] of String;
  STR_NAVIGATORBAR: array[1..MAX_NAVIGATORBAR] of String;
  STR_PROJECTBAR: array[1..MAX_PROJECTBAR] of String;
  STR_HELPBAR: array[1..MAX_HELPBAR] of String;
  STR_DEBUGBAR: array[1..MAX_DEBUGBAR] of String;

  STR_POPUP_PROJ: array[1..MAX_POPUP_PROJ] of String;
  STR_POPUP_EDITOR: array[1..MAX_POPUP_EDITOR] of String;
  STR_POPUP_TABS: array[1..MAX_POPUP_TABS] of String;

  STR_FRM_MAIN: array[1..MAX_FRM_MAIN] of String;
  STR_FRM_PROP: array[1..MAX_FRM_PROP] of String;
  STR_FRM_NEW_PROJ: array[1..MAX_FRM_NEW_PROJ] of String;
  STR_CMPMSG: array[1..MAX_CMPMSG] of String;
  STR_FRM_UPD: array[1..MAX_FRM_UPD] of String;
  STR_FRM_FIND: array[1..MAX_FRM_FIND] of String;

implementation

uses UFrmProperty, UUtils, UFrmOptions, UFrmUpdate, UFrmMain,
  UFrmCompOptions, UFrmEditorOptions, UFrmEnvOptions;

constructor TFalconLanguages.Create;
var
  LangItem: TLanguageProperty;
begin
  inherited Create;
  FList := TStringList.Create;
  LangItem := TLanguageProperty.Create;
  LangItem.ID := $0409;
  LangItem.ImageIndex := 220;
  LangItem.Name := 'English';
  LangItem.Translator := '';
  LangItem.Version := '1.0';
  FList.AddObject('', LangItem);
  LangDefault := True;
end;

destructor TFalconLanguages.Destroy;
begin
  Clear;
  if FList.Count = 1 then
    FList.Objects[0].Free;//English
  FList.Free;
  inherited Destroy;
end;

function TFalconLanguages.GetItem(Index: Integer): TLanguageProperty;
begin
  Result := nil;
  if (Index < 0) or (Index >= FList.Count) then
    Exit;
  Result :=  TLanguageProperty(FList.Objects[Index]);
end;

function TFalconLanguages.GetCount: Integer;
begin
  Result :=  FList.Count;
end;

procedure TFalconLanguages.Clear;
var
  I: Integer;
begin
  for I := Count - 1 downto 1 do
  begin
    FList.Objects[I].Free;
    FList.Delete(I);
  end;
end;

procedure TFalconLanguages.SetLangDefault(Value: Boolean);
var
  I: Integer;
begin
  if Value then
  begin
    FCurrent := TLanguageProperty(FList.Objects[0]);
    for I := 1 to MAX_MENUS do
      STR_MENUS[I] := CONST_STR_MENUS[I];
    for I := 1 to MAX_MENU_FILE do
      STR_MENU_FILE[I] := CONST_STR_MENU_FILE[I];
    for I := 1 to MAX_MENU_EDIT do
      STR_MENU_EDIT[I] := CONST_STR_MENU_EDIT[I];
    for I := 1 to MAX_MENU_SERH do
      STR_MENU_SERH[I] := CONST_STR_MENU_SERH[I];
    for I := 1 to MAX_MENU_VIEW do
      STR_MENU_VIEW[I] := CONST_STR_MENU_VIEW[I];
    for I := 1 to MAX_MENU_PROJ do
      STR_MENU_PROJ[I] := CONST_STR_MENU_PROJ[I];
    for I := 1 to MAX_MENU_RUN do
      STR_MENU_RUN[I] := CONST_STR_MENU_RUN[I];
    for I := 1 to MAX_MENU_TOOL do
      STR_MENU_TOOL[I] := CONST_STR_MENU_TOOL[I];
    for I := 1 to MAX_MENU_HELP do
      STR_MENU_HELP[I] := CONST_STR_MENU_HELP[I];
    //sub menu new
    for I := 1 to MAX_NEW_MENU do
      STR_NEW_MENU[I] := CONST_STR_NEW_MENU[I];
    //sub menu toolars
    for I := 1 to MAX_VIEWTOOLBAR_MENU do
      STR_VIEWTOOLBAR_MENU[I] := CONST_STR_VIEWTOOLBAR_MENU[I];


    for I := 1 to MAX_DEFAULTBAR do
      STR_DEFAULTBAR[I] := CONST_STR_DEFAULTBAR[I];
    for I := 1 to MAX_EDITBAR do
      STR_EDITBAR[I] := CONST_STR_EDITBAR[I];
    for I := 1 to MAX_SEARCHBAR do
      STR_SEARCHBAR[I] := CONST_STR_SEARCHBAR[I];
    for I := 1 to MAX_COMPILERBAR do
      STR_COMPILERBAR[I] := CONST_STR_COMPILERBAR[I];
    for I := 1 to MAX_NAVIGATORBAR do
      STR_NAVIGATORBAR[I] := CONST_STR_NAVIGATORBAR[I];
    for I := 1 to MAX_PROJECTBAR do
      STR_PROJECTBAR[I] := CONST_STR_PROJECTBAR[I];
    for I := 1 to MAX_PROJECTBAR do
      STR_PROJECTBAR[I] := CONST_STR_PROJECTBAR[I];
    for I := 1 to MAX_HELPBAR do
      STR_HELPBAR[I] := CONST_STR_HELPBAR[I];
    for I := 1 to MAX_DEBUGBAR do
      STR_DEBUGBAR[I] := CONST_STR_DEBUGBAR[I];

    for I := 1 to MAX_POPUP_PROJ do
      STR_POPUP_PROJ[I] := CONST_STR_POPUP_PROJ[I];
    for I := 1 to MAX_POPUP_EDITOR do
      STR_POPUP_EDITOR[I] := CONST_STR_POPUP_EDITOR[I];
    for I := 1 to MAX_POPUP_TABS do
      STR_POPUP_TABS[I] := CONST_STR_POPUP_TABS[I];

    for I := 1 to MAX_FRM_MAIN do
      STR_FRM_MAIN[I] := CONST_STR_FRM_MAIN[I];
    for I := 1 to MAX_FRM_PROP do
      STR_FRM_PROP[I] := CONST_STR_FRM_PROP[I];
    for I := 1 to MAX_FRM_NEW_PROJ do
      STR_FRM_NEW_PROJ[I] := CONST_STR_FRM_NEW_PROJ[I];
    for I := 1 to MAX_CMPMSG do
      STR_CMPMSG[I] := CONST_STR_CMPMSG[I];
    for I := 1 to MAX_FRM_UPD do
      STR_FRM_UPD[I] := CONST_STR_FRM_UPD[I];
    for I := 1 to MAX_FRM_FIND do
      STR_FRM_FIND[I] := CONST_STR_FRM_FIND[I];
  end;
  FDefault := Value;
end;

function TFalconLanguages.GetLangByID(LangID: Word): String;
var
  LangItem: TLanguageProperty;
  I: Integer;
begin
  Result := '';
  for I:= 0 to Pred(FList.Count) do
  begin
    LangItem := TLanguageProperty(FList.Objects[I]);
    if (LangItem.ID = LangID) then
    begin
      Result := LangItem.Name;
      Exit;
    end;
  end;
end;

function TFalconLanguages.GetImageIndexByID(LangID: Word): Integer;
var
  LangItem: TLanguageProperty;
  I: Integer;
begin
  Result := -1;
  for I:= 0 to Pred(FList.Count) do
  begin
    LangItem := TLanguageProperty(FList.Objects[I]);
    if (LangItem.ID = LangID) then
    begin
      Result := LangItem.ImageIndex;
      Exit;
    end;
  end;
end;

function TFalconLanguages.Load: Boolean;
var
  Files: TStrings;
  LangItem: TLanguageProperty;
  Temp: String;
  I: Integer;
  SaveID: Cardinal;
  ini: TIniFile;
begin
  Files := TStringList.Create;
  SaveID := FCurrent.ID;
  Clear;
  FindFiles(LangDir + '*.lng', Files);
  for I:= 0 to Pred(Files.Count) do
  begin
    Temp := LangDir + Files.Strings[I];
    ini := TIniFile.Create(Temp);
    LangItem := TLanguageProperty.Create;
    LangItem.ID := ini.ReadInteger('FALCON', 'LangID', 0);
    LangItem.ImageIndex := ini.ReadInteger('FALCON', 'ImageIndex', -1);
    LangItem.Name := ini.ReadString('FALCON', 'LangName', '');
    LangItem.Translator := ini.ReadString('FALCON', 'Name', '');
    LangItem.Email := ini.ReadString('FALCON', 'Email', '');
    LangItem.Version := ini.ReadString('FALCON', 'Version', '1.0');
    FList.AddObject(Temp, LangItem);
    if SaveID = LangItem.ID then
      FCurrent := LangItem;
    ini.Free;
  end;
  Files.Free;
  Result := True;
end;

procedure TFalconLanguages.UpdateForms;
begin
    if Assigned(FrmOptions) then
    FrmOptions.UpdateLangNow;
  if Assigned(FrmEnvOptions) then
    FrmEnvOptions.UpdateLangNow;
  if Assigned(FrmCompOptions) then
    FrmCompOptions.UpdateLangNow;
  if Assigned(FrmEditorOptions) then
    FrmEditorOptions.UpdateLangNow;
  if Assigned(FrmUpdate) then
    FrmUpdate.UpdateLangNow;
  FrmFalconMain.UpdateLangNow;
end;

function TFalconLanguages.UpdateLang(LangName: String): Boolean;
var
  LangProp: TLanguageProperty;
  Temp: String;
  I: Integer;
  ini: TIniFile;

  function ReadStr(const Ident: Integer; const Default: String): String;
  begin
    Result := ini.ReadString('FALCON', IntToStr(Ident), Default);
  end;

begin
  Result := False;
  Temp := '';
  for I:= 0 to Pred(FList.Count) do
  begin
    LangProp := TLanguageProperty(FList.Objects[I]);
    if (LangProp.Name = LangName) then
    begin
      Temp := FList.Strings[I];
      FCurrent := LangProp;
      Break;
    end;
  end;

  if not FileExists(Temp) then
  begin
    if FCurrent.Name = 'English' then
    begin
      SetLangDefault(True);
      UpdateForms;
      Result := True;
      Exit;
    end;
    Exit;
  end;
  ini := TIniFile.Create(Temp);
  //init
  for I := 1 to MAX_MENUS do //1
    STR_MENUS[I] := ReadStr(I, CONST_STR_MENUS[I]);
  for I := 1 to MAX_MENU_FILE do//109
    STR_MENU_FILE[I] := ReadStr(I + 108, CONST_STR_MENU_FILE[I]);
  for I := 1 to MAX_MENU_EDIT do//221
    STR_MENU_EDIT[I] := ReadStr(I + 220, CONST_STR_MENU_EDIT[I]);
  for I := 1 to MAX_MENU_SERH do//334
    STR_MENU_SERH[I] := ReadStr(I + 333, CONST_STR_MENU_SERH[I]);
  for I := 1 to MAX_MENU_VIEW do//391
    STR_MENU_VIEW[I] := ReadStr(I + 390, CONST_STR_MENU_VIEW[I]);
  for I := 1 to MAX_MENU_PROJ do//435
    STR_MENU_PROJ[I] := ReadStr(I + 434, CONST_STR_MENU_PROJ[I]);
  for I := 1 to MAX_MENU_RUN do//541
    STR_MENU_RUN[I] := ReadStr(I + 540, CONST_STR_MENU_RUN[I]);
  for I := 1 to MAX_MENU_TOOL do//646
    STR_MENU_TOOL[I] := ReadStr(I + 645, CONST_STR_MENU_TOOL[I]);
  for I := 1 to MAX_MENU_HELP do//854
    STR_MENU_HELP[I] := ReadStr(I + 853, CONST_STR_MENU_HELP[I]);

  for I := 1 to MAX_NEW_MENU do//959
    STR_NEW_MENU[I] := ReadStr(I + 958, CONST_STR_NEW_MENU[I]);

  //sub menu toolars
  for I := 1 to MAX_VIEWTOOLBAR_MENU do//978
    STR_VIEWTOOLBAR_MENU[I] := ReadStr(I + 977, CONST_STR_VIEWTOOLBAR_MENU[I]);

    for I := 1 to MAX_DEFAULTBAR do//1067
      STR_DEFAULTBAR[I] := ReadStr(I + 1066, CONST_STR_DEFAULTBAR[I]);
    for I := 1 to MAX_EDITBAR do//1080
      STR_EDITBAR[I] := ReadStr(I + 1079, CONST_STR_EDITBAR[I]);
    for I := 1 to MAX_SEARCHBAR do//1138
      STR_SEARCHBAR[I] := ReadStr(I + 1137, CONST_STR_SEARCHBAR[I]);
    for I := 1 to MAX_COMPILERBAR do//1098
      STR_COMPILERBAR[I] := ReadStr(I + 1097, CONST_STR_COMPILERBAR[I]);
    for I := 1 to MAX_NAVIGATORBAR do//1089
      STR_NAVIGATORBAR[I] := ReadStr(I + 1088, CONST_STR_NAVIGATORBAR[I]);
    for I := 1 to MAX_PROJECTBAR do//1119
      STR_PROJECTBAR[I] := ReadStr(I + 1118, CONST_STR_PROJECTBAR[I]);
    for I := 1 to MAX_HELPBAR do//1110
      STR_HELPBAR[I] := ReadStr(I + 1109, CONST_STR_HELPBAR[I]);
    for I := 1 to MAX_DEBUGBAR do//1128
      STR_DEBUGBAR[I] := ReadStr(I + 1127, CONST_STR_DEBUGBAR[I]);

  for I := 1 to MAX_POPUP_PROJ do//1181
    STR_POPUP_PROJ[I] := ReadStr(I + 1180, CONST_STR_POPUP_PROJ[I]);
  for I := 1 to MAX_POPUP_EDITOR do//1291
    STR_POPUP_EDITOR[I] := ReadStr(I + 1290, CONST_STR_POPUP_EDITOR[I]);
  for I := 1 to MAX_POPUP_TABS do//1351
    STR_POPUP_TABS[I] := ReadStr(I + 1350, CONST_STR_POPUP_TABS[I]);

  for I := 1 to MAX_FRM_MAIN do//1405
    STR_FRM_MAIN[I] := ReadStr(I + 1404, CONST_STR_FRM_MAIN[I]);
  for I := 1 to MAX_FRM_PROP do//1528
    STR_FRM_PROP[I] := ReadStr(I + 1527, CONST_STR_FRM_PROP[I]);
  for I := 1 to MAX_FRM_NEW_PROJ do//1673
    STR_FRM_NEW_PROJ[I] := ReadStr(I + 1672, CONST_STR_FRM_NEW_PROJ[I]);
  for I := 1 to MAX_CMPMSG do//1785
    STR_CMPMSG[I] := ReadStr(I + 1784, CONST_STR_CMPMSG[I]);
  for I := 1 to MAX_FRM_UPD do//4001
    STR_FRM_UPD[I] := ReadStr(I + 4000, CONST_STR_FRM_UPD[I]);
  for I := 1 to MAX_FRM_FIND do//4201
    STR_FRM_FIND[I] := ReadStr(I + 4200, CONST_STR_FRM_FIND[I]);
  STR_FRM_FIND[30] := StringReplace(STR_FRM_FIND[30], '\n', #13, [rfReplaceAll]);
  //end
  ini.Free;
  UpdateForms;
end;

end.
