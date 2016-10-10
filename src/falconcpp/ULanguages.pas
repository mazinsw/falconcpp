unit ULanguages;

interface

uses
  Windows, SysUtils, Classes, Dialogs, Controls,
  IniFiles, ImgList;

type
  TCompilerMessage = record
    Expression: string;
    FileName: Integer;
    Line: Integer;
    Column: Integer;
  end;

const
  APS = '''';

  MAX_MENUS = 8;
  CONST_STR_MENUS: array[1..MAX_MENUS] of string = (
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
  CONST_STR_MENU_FILE: array[1..MAX_MENU_FILE] of string = (
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
  MAX_MENU_EDIT = 24;
  CONST_STR_MENU_EDIT: array[1..MAX_MENU_EDIT] of string = (
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
    'Toggle Line Comment',
    '',
    'Format',
    '',
    'Collapse All',
    'Uncollapse All'
    );

  MAX_MENU_SERH = 11;
  CONST_STR_MENU_SERH: array[1..MAX_MENU_SERH] of string = (
  //Search Menu
    'Find...',
    'Find Next',
    'Find Previous',
    'Find in Files...',
    'Replace...',
    'Incremental Search...',
    '',
    'Goto Function...',
    'Goto Previous Function',
    'Goto Next Function',
    'Goto Line Number...'
    );

  MAX_MENU_VIEW = 11;
  CONST_STR_MENU_VIEW: array[1..MAX_MENU_VIEW] of string = (
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
  CONST_STR_MENU_PROJ: array[1..MAX_MENU_PROJ] of string = (
  //Project Menu
    'Add...',
    'Remove...',
    '',
    'Build',
    '',
    'Properties...'
    );

  MAX_MENU_RUN = 10;
  CONST_STR_MENU_RUN: array[1..MAX_MENU_RUN] of string = (
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
  CONST_STR_MENU_TOOL: array[1..MAX_MENU_TOOL] of string = (
  //Tools Menu
    'Environment Options...',
    'Compiler Options...',
    'Editor Options...',
    '',
    'Template Creator...',
    'Package Creator...',
    '',
    'Packages...'
    );

  MAX_MENU_HELP = 6;
  CONST_STR_MENU_HELP: array[1..MAX_MENU_HELP] of string = (
  //Help Menu
    'Falcon Help',
    'Tip of the Day...',
    '',
    'Update',
    '',
    'About...'
    );

  MAX_NEW_MENU = 9;
  CONST_STR_NEW_MENU: array[1..MAX_NEW_MENU] of string = (
  //New From Menu File
    '&Project...',
    'C File',
    'C++ File',
    'Header File',
    'Resource File',
    'Empty File',
    '',
    'Folder',
    'Configuration'
    );

  MAX_IMPORT_MENU = 3;
  CONST_STR_IMPORT_MENU: array[1..MAX_IMPORT_MENU] of string = (
  //Import From Menu File
    'Dev-C++ Project',
    'Code::Blocks Project',
    'MS Visual C++ Project'
    );

  MAX_VIEWTOOLBAR_MENU = 8;
  CONST_STR_VIEWTOOLBAR_MENU: array[1..MAX_VIEWTOOLBAR_MENU] of string = (
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
  CONST_STR_DEFAULTBAR: array[1..MAX_DEFAULTBAR] of string = (
  //DefaultBar
    'New',
    'Open',
    'Remove',
    '',
    'Save',
    'Save All'
    );

  MAX_EDITBAR = 2;
  CONST_STR_EDITBAR: array[1..MAX_EDITBAR] of string = (
  //EditBar
    'Undo',
    'Redo'
    );

  MAX_NAVIGATORBAR = 5;
  CONST_STR_NAVIGATORBAR: array[1..MAX_NAVIGATORBAR] of string = (
  //NavigatorBar
    'Previous Page',
    'Next Page',
    '',
    'Toggle Bookmarks',
    'Goto Bookmarks'
    );

  MAX_COMPILERBAR = 5;
  CONST_STR_COMPILERBAR: array[1..MAX_COMPILERBAR] of string = (
  //CompilerBar
    'Run',
    'Compile',
    'Execute',
    '',
    'Stop'
    );

  MAX_HELPBAR = 2;
  CONST_STR_HELPBAR: array[1..MAX_HELPBAR] of string = (
  //HelpBar
    'Help',
    'Context Help'
    );

  MAX_PROJECTBAR = 2;
  CONST_STR_PROJECTBAR: array[1..MAX_PROJECTBAR] of string = (
  //ProjectBar
    'New Project',
    'Properties'
    );

  MAX_DEBUGBAR = 3;
  CONST_STR_DEBUGBAR: array[1..MAX_DEBUGBAR] of string = (
  //DebugBar
    'Step Into',
    'Step Over',
    'Step Return'
    );

  MAX_SEARCHBAR = 4;
  CONST_STR_SEARCHBAR: array[1..MAX_SEARCHBAR] of string = (
  //SearchBar
    'Find',
    'Replace',
    '',
    'Goto Line Number'
    );

  MAX_POPUP_PROJ = 11;
  CONST_STR_POPUP_PROJ: array[1..MAX_POPUP_PROJ] of string = (
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
  CONST_STR_POPUP_EDITOR: array[1..MAX_POPUP_EDITOR] of string = (
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

  MAX_POPUP_TABS = 19;
  CONST_STR_POPUP_TABS: array[1..MAX_POPUP_TABS] of string = (
  //PopupMenu from PageControl
    '&Close',
    'Close &all',
    'Close all others',
    '',
    'Save',
    'Save all',
    '',
    'Copy full filename',
    'Copy filename',
    'Copy directory path',
    '',
    'Swap header/source',
    '',
    'Read only',
    '',
    'Tabs at top',
    'Tabs at bottom',
    '',
    'Properties...'
    );

  MAX_POPUP_MSGS = 7;
  CONST_STR_POPUP_MSGS: array[1..MAX_POPUP_MSGS] of string = (
  //PopupMenu from Messages
    'Copy',
    'Copy original message',
    '',
    'Original message',
    '',
    'Goto line',
    'Clear'
    );

  MAX_FRM_MAIN = 54;
  CONST_STR_FRM_MAIN: array[1..MAX_FRM_MAIN] of string = (
    //Tabs Left
    'Projects',
    'Explorer',
    //Tabs Right
    'Outline',
    //Tabs Down
    'Messages',
    '', // Old chat
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
    'Compilation success in %s s',
    'Compilation failed',
    'Adding messages %d/%d',
    'Parsing results %d/%d',
    'Do you want to create it?',
    'Debugging',
    'Loading configurations...',
    'Compiler was not detected!',
    'Can''t import %s project!',
    '%s Project',
    'This file has been modified by another program.'#13 +
    'Do you want to reload it?',
    'Variables',
    'Continue',
    'Delete folder "%s" from project?',
    'Delete folder "%s" from disk?',
    'The file "%s" already exists.'#13 +
    'Do you want to override it?'
    );

  MAX_FRM_PROP = 57;
  CONST_STR_FRM_PROP: array[1..MAX_FRM_PROP] of string = (
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
    'Console Application',
    'Windows Application',
    'Dinamic Link Library',
    'Static Library',
    'Enable theme',
    'Requires admin level',
    'Create linked library',
    'Select folder to include',
    'Edit selected',
    'Select library folder'
    );

  MAX_FRM_NEW_PROJ = 12;
  CONST_STR_FRM_NEW_PROJ: array[1..MAX_FRM_NEW_PROJ] of string = (
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

  MAX_FRM_FIND = 34;
  CONST_STR_FRM_FIND: array[1..MAX_FRM_FIND] of string = (
    //Find/Replace Form
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
    'Find ''%s'' in file ''%s''',
    'Found ''%s'' in line %d, column %d'
    );

  MAX_FRM_EDITOR_OPT = 139;
  CONST_STR_FRM_EDITOR_OPT: array[1..MAX_FRM_EDITOR_OPT] of string = (
    'Editor Options',
  //General Sheet
    'General',
    'Editor Options',
    'Auto Indent',
    '',
    'Insert Mode',
    'Group Undo',
    'Keep Trailing Spaces',
    'Show Space and Tab Characters',
    'Scroll Hint',
    'Tab Indent/Unindent',
    'Smart Tabs',
    'Use Tab Character',
    'Enhanced Home Key',
    'Max Undo:',
    'Tab Width:',
    'Highligth matching braces/parentheses',
    'Normal Color',
    'Error Color',
    'Background Color',
    'Highligth current line',
    'Color',
    'Link click',
    'Restore Default',
  //Display Sheet
    'Display',
    'Editor font:',
    'Size:',
    'Sample:',
    'Margin and gutter',
    'Show right margin',
    'Show gutter',
    'Show line gutter',
    'Gradient gutter',
    'Right margin:',
    'Gutter width:',
  //Colors Sheet
    'Colors',
    'Type:',
    'Defined sintax:',
    'Save sintax',
    'Delete sintax',
    'Foreground:',
    'Background:',
    'Styles',
    'Bold',
    'Italic',
    'Underlined',
    'New Sintax',
  //Formatter
    'Formatter',
    //Style
    'Style',
    'Custom',
    'Preview',
    'Sample',
    //Indentation
    'Indentation',
    'Force using TABs',
    'Indent classes (keywords public:, protected: and private:)',
    'Indent switches (keyword case:)',
    'Indent case: statements in switches (commands case:)',
    'Indent brackets',
    'Indent blocks',
    'Indent namespaces',
    'Indent labels',
    'Indent mult-line preprocessor definitions',
    'Indent single line comments',
    //hints
    'Indent using tab characters.',
    'Indent ''class'' and ''struct'' blocks so that the blocks ''public:''' +
    ', ''protected:'' and ''private:'' are indented. The struct blocks' +
    ' are'#13'indented only if an access modifier is declared somewhere ' +
    'in the struct. The entire block is indented. This option is '#13 +
    'effective for C++ files only.',
    'Indent ''switch'' blocks so that the ''case X:'' statements are ' +
    'indented in the switch block. The entire case block is indented.',
    'Indent ''case X:'' blocks from the ''case X:'' headers. Case statements' +
    ' not enclosed in blocks are NOT indented.',
    'Add extra indentation to namespace blocks.',
    'Add extra indentation to labels so they appear 1 indent less than the ' +
    'current indentation, '#13'rather than being flushed to the left (the' +
    ' default).',
    'Indent multi-line preprocessor definitions ending with a backslash. ' +
    'Should be used with --convert-tabs for proper results. '#13'Does a' +
    ' pretty good job, but cannot perform miracles in obfuscated ' +
    'preprocessor definitions. Without this option the '#13'preprocessor ' +
    'statements remain unchanged.',
    'Indent C++ comments beginning in column one. By default C++ comments ' +
    'beginning in column one are not indented. '#13'This option will ' +
    'allow the comments to be indented with the code.',
    //Padding sheet
    'Padding',
    'Pad empty lines around header blocks (''if'', ''while'', ..)',
    'Break closing header blocks',
    'Insert space padding around operators',
    'Insert space padding around parenthesis on the outside',
    'Insert space padding around parenthesis on the inside',
    'Parenthesis header padding',
    'Remove extra space padding around parenthesis',
    'Delete empty lines',
    'Fill empty lines with the whitespace of their previous lines',
    //hints
    'Pad empty lines around header blocks (e.g. ''if'', ''for'', ''while''...).',
    'Pad empty lines around header blocks (e.g. ''if'', ''for'', ''while''...).' +
    ' Treat closing header blocks (e.g. ''else'', ''catch'') as '#13 +
    'stand-alone blocks.',
    'Insert space padding around operators. Any end of line comments will ' +
    'remain in the original column, if possible. '#13'Note that there is' +
    ' no option to unpad. Once padded, they stay padded.',
    'Insert space padding around parenthesis on the outside only. Any end ' +
    'of line comments will remain in the original column, '#13'if possible.',
    'Insert space padding around parenthesis on the inside only. Any end of ' +
    'line comments will remain in the original column, '#13'if possible.',
    'Insert space padding after paren headers only (e.g. ''if'', ''for'', ' +
    '''while''...). Any end of line comments will remain in the '#13 +
    'original column, if possible.',
    'Remove extra space padding around parenthesis on the inside and outside.' +
    ' Any end of line comments will remain in the '#13'original column, ' +
    'if possible.',
    'Delete empty lines within a function or method. Empty lines outside of ' +
    'functions or methods are NOT deleted.',
    'Fill empty lines with the white space of the previous line.',
    //Formatting
    'Formatting',
    'Brackets style:',
    'None',
    'Break',
    'Attach',
    'Linux',
    'Break closing headers brackets',
    'Break ''else if()'' header combinations into separate lines',
    'Add brackets',
    'Add one line brackets',
    'Don''t break one-line blocks',
    'Don''t break complex statements and multiple statements residing in a ' +
    'single line',
    'Convert TABs to spaces',
    //hints
    'When used with brackets=attach, brackets=linux, this breaks closing ' +
    'headers (e.g. ''else'', ''catch'', ...) from their'#13'immediately ' +
    'preceding closing brackets. Closing header brackets are always broken' +
    ' with broken brackets, horstmann '#13'brackets, indented blocks, and ' +
    'indented brackets.',
    'Break "else if" header combinations into separate lines. This option has' +
    ' no effect if keep one line statements is used, the'#13'"else if" ' +
    'statements will remain as they are.'#13'If this option is NOT used, ' +
    '"else if" header combinations will be placed on a single line.',
    'Add brackets to unbracketed one line conditional statements (e.g. ''if''' +
    ''', ''for'', ''while''...). The statement must be on a single '#13 +
    'line. The brackets will be added according to the currently requested ' +
    'predefined style or bracket type. If no style or '#13'bracket type is ' +
    'requested the brackets will be attached. If add one line brackets is ' +
    'also used the result will be one line '#13'brackets.',
    'Add one line brackets to unbracketed one line conditional statements  ' +
    '(e.g. ''if'', ''for'', ''while''...). The statement must be on'#13'a ' +
    'single line. The option implies keep one line blocks and will not ' +
    'break the one line blocks.',
    'Don''t break one-line blocks.',
    'Don''t break complex statements and multiple statements residing on a ' +
    'single line.',
    'Converts tabs into spaces in the non-indentation part of the line. The ' +
    'number of spaces inserted will maintain the spacing '#13'of the tab. ' +
    'The current setting for spaces per tab is used. It may not produce ' +
    'the expected results if convert-tabs is used'#13'when changing spaces' +
    ' per tab. Tabs are not replaced in quotes.',
    'Pointer align:',
    'None',
    'Type',
    'Middle',
    'Name',
    'Attach a pointer or reference operator (* or &) to either the variable' +
    ' type (left) or variable name (right), or place it'#13'between the ' +
    'type and name (middle). The spacing between the type and name will ' +
    'be preserved, if possible. To format'#13'references separately use ' +
    'the following align-reference option.',
  //Code Resources
    'Code Resources',
    'Automatic features',
    'Code completion',
    'Code parameters',
    'Tooltip expression evaluation',
    'Tooltip symbol',
    '&Delay:',
    '%.1f sec',
    'Completion List Colors',
    'Constant Symbol:',
    'Function Symbol:',
    '&Variable Symbol:',
    'Type Symbol:',
    'Typedef Symbol:',
    'Preprocessor:',
    'Selected:',
    'Background:',
    'Code Templates',
    'Custom Code Template File:',
    'Open',
    'Edit',
    'Auto close brackets/parentheses',
    'Cursor past EOL'
    );

  MAX_FRM_ENV_OPT = 36;
  CONST_STR_FRM_ENV_OPT: array[1..MAX_FRM_ENV_OPT] of string = (
    'Environment Options',
    //General
    'General',
    'Default to C++ on new file',
    'Show toolbars in full screen',
    'Remove file on close',
    'One click to open file',
    'Check for updates automatically',
    'Create layout files',
    'Ask if you want to delete the project file',
    'Run console applications in console runner',
    'Auto open',
    'All projects files',
    'All files of last section',
    'Only last open file',
    'Only first project',
    'None',
    //Interface
    'Interface',
    'Max files in reopen menu',
    'Language:',
    'Show splash screen',
    'Theme',
    //Files and Directories
    'Files and Directories',
    'Alternative configuration file',
    'Configuration file',
    'User''s default directory',
    'Templates directory',
    'Language files directory',
    'Projects directory',
    'Help/Documentation directory',
    'Examples directory',
    'Open',
    'View',
    'Select',
    'Select directory',
    'Restart application to apply changes',  { TODO -oMazin -c : Re-use unused 19/05/2013 20:28:10 }
    'Configuration files'
    );

  MAX_FRM_CODE_TEMPL = 6;
  CONST_STR_FRM_CODE_TEMPL: array[1..MAX_FRM_CODE_TEMPL] of string = (
    'Templates',
    'Code',
    'Invalid Name!',
    'Name already exist',
    'Add Code Template',
    'Edit Code Template'
    );

  MAX_FRM_PROMPT_CODE = 2;
  CONST_STR_FRM_PROMPT_CODE: array[1..MAX_FRM_PROMPT_CODE] of string = (
    'Name',
    'Description'
    );

  MAX_FRM_ABOUT = 6;
  CONST_STR_FRM_ABOUT: array[1..MAX_FRM_ABOUT] of string = (
    'About',
    'Compatibility: %s',
    'Licence',
    'Developers',
    'Translators',
    'Testers'
    );

  MAX_FRM_GOTOLINE = 2;
  CONST_STR_FRM_GOTOLINE: array[1..MAX_FRM_GOTOLINE] of string = (
    'Goto Line',
    'Line (%d - %d):'
    );

  MAX_FRM_GOTOFUNC = 6;
  CONST_STR_FRM_GOTOFUNC: array[1..MAX_FRM_GOTOFUNC] of string = (
    'Goto Function',
    'Function name',
    'Name',
    'Return type',
    'Line',
    'File'
    );

  MAX_FRM_UPD = 25;
  CONST_STR_FRM_UPD: array[1..MAX_FRM_UPD] of string = (
    'Application Update',
    'Looking for updates',
    '&Update',
    'Falcon C++ is open, do you want to close it!',
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

  //Translate mingw messages
  MAX_CMPMSG = 189;
  CONST_STR_CMPMSG: array[1..MAX_CMPMSG] of TCompilerMessage = (
{001} (Expression: '^([a-zA-Z]?:?[^:]+): In function ''(.*)'':$'; FileName: 1; Line: 0; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: implicit declaration of function ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: assignment makes pointer from integer without a cast$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+):([0-9]+): error: invalid suffix "(.*)" on integer constant$'; FileName: 1; Line: 2; Column: 3),
      (Expression: '^([a-zA-Z]?:?[^:]+):[0-9]+?:([0-9]+): warning: unused variable ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: ''(.*)'' was not declared in this scope$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: expected ''(.*)'' before ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+):([0-9]+): error: macro "(.*)" passed ([0-9]+) arguments, but takes just ([0-9]+)$'; FileName: 1; Line: 2; Column: 3),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+):([0-9]+): error: macro "(.*)" requires ([0-9]+) arguments, but only ([0-9]+) given$'; FileName: 1; Line: 2; Column: 3),
{010} (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: at this point in file$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: too many arguments to function ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: ''(.*)'' undeclared \(first use in this function\)$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: expected ''(.*)'' before numeric constant$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: \(Each undeclared identifier is reported only once for each function it appears in\.\)$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: statement has no effect$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: passing argument ([0-9]+) of ''(.*)'' makes integer from pointer without a cast$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): note: expected ''(.*)'' but argument is of type ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: invalid conversion from ''(.*)'' to ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error:   initializing argument ([0-9]+) of ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
{020} (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: too few arguments to function ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): undefined reference to `(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: cannot convert ''(.*)'' to ''(.*)'' for argument ''(.*)'' to ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: value computed is not used$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: ''(.*)'' is used uninitialized in this function$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: base operand of ''(.*)'' has non-pointer type ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+):([0-9]+): error: (.*): No such file or directory$'; FileName: 1; Line: 2; Column: 3),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: ''(.*)'' does not name a type$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: expected initializer before ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: a function-definition is not allowed here before ''(.*)'' token expected ''(.*)'' at end of input$'; FileName: 1; Line: 2; Column: 0),
{030} (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: return makes integer from pointer without a cast$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: overflow in implicit constant conversion$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: integer constant is too large for ''(.*)'' type$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+):([0-9]+): warning: integer constant is too large for its type$'; FileName: 1; Line: 2; Column: 3),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: this decimal constant is unsigned only in ISO C90$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: expected ''(.*)'' before ''(.*)'' token$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: expected expression before ''(.*)'' token$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): note: ''(.*)'' was declared here$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: statement with no effect$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: lvalue required as left operand of assignment$'; FileName: 1; Line: 2; Column: 0),
{040} (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: type defaults to ''(.*)'' in declaration of ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: initialization makes integer from pointer without a cast$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+):([0-9]+): warning: character constant too long for its type$'; FileName: 1; Line: 2; Column: 3),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: expected identifier or ''(.*)'' before numeric constant$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: expected ''='', '','', '';'', ''asm'' or ''__attribute__'' before ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: label ''(.*)'' defined but not used$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: ''(.*)'' has no member named ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: array subscript is not an integer$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: too few arguments for format$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: format ''(.*)'' expects type ''(.*)'', but argument ([0-9]+) has type ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
{050} (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: switch quantity not an integer$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: incompatible type for argument ([0-9]+) of ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: expected statement before ''(.*)'' token$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: control reaches end of non-void function$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: ''(.*)'' may be used uninitialized in this function$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: missing braces around initializer$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: (near initialization for ''(.*)'')$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: statement is a reference, not call, to function ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: case label ''(.*)'' not within a switch statement$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: expected primary-expression before ''(.*)'' token$'; FileName: 1; Line: 2; Column: 0),
{060} (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: no return statement in function returning non-void$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: expected unqualified-id before ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: array subscript is above array bounds$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: suggest parentheses around assignment used as truth value$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: storage size of ''(.*)'' isn''t known$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: invalid application of ''(.*)'' to incomplete type ''(.*)'' $'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: incompatible implicit declaration of built-in function ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: comparison between signed and unsigned integer expressions$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: deprecated conversion from string constant to ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: expected class-name before ''(.*)'' token$'; FileName: 1; Line: 2; Column: 0),
{070} (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: ISO C\+\+ forbids declaration of ''(.*)'' with no type$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):(.*): error: typedef ''(.*)'' is initialized (use decltype instead)$'; FileName: 1; Line: 0; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: expected constructor, destructor, or type conversion before ''(.*)'' token$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: expected initializer before ''(.*)'' token$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: expected constructor, destructor, or type conversion before ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^In file included from (.*):([0-9]+):$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):(.*):\((.*)\): first defined here$'; FileName: 1; Line: 0; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: enumeration value ''(.*)'' not handled in switch$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+): In member function ''(.*)'':$'; FileName: 1; Line: 0; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: stray ''(.*)'' in program$'; FileName: 1; Line: 2; Column: 0),
{080} (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: expected ''(.*)'' at end of input$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: field width should have type ''(.*)'', but argument ([0-9]+) has type ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: subscripted value is neither array nor pointer$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: array type has incomplete element type$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: too many arguments for format$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: operation on ''(.*)'' may be undefined$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+):([0-9]+): error: unterminated comment$'; FileName: 1; Line: 2; Column: 3),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+):([0-9]+): warning: "(.*)" within comment$'; FileName: 1; Line: 2; Column: 3),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+):([0-9]+): warning: missing terminating (.*) character$'; FileName: 1; Line: 2; Column: 3),
      (Expression: '^([a-zA-Z]?:?[^:]+): cannot open output file (.*): No such file or directory$'; FileName: 1; Line: 0; Column: 0),
{090} (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: missing terminating (.*) character$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: array size missing in ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: passing argument ([0-9]+) of ''(.*)'' from incompatible pointer type$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: return type defaults to ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: expected identifier or ''(.*)'' before ''(.*)'' token$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: expected identifier or ''(.*)'' at end of input$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: expected specifier-qualifier-list before ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: declaration does not declare anything$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: bit-field ''(.*)'' width not an integer constant$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: ''(.*)'' undeclared here \(not in a function\)$'; FileName: 1; Line: 2; Column: 0),
{100} (Expression: '^([a-zA-Z]?:?[^:]+): warning: ''(.*)'' after last input file has no effect$'; FileName: 1; Line: 0; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+): no input files$'; FileName: 1; Line: 0; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+): preprocessing failed\.$'; FileName: 1; Line: 0; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: zero width for bit-field ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: width of ''(.*)'' exceeds its type$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: braces around scalar initializer$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: initialization from incompatible pointer type$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: excess elements in scalar initializer$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: left-hand operand of comma expression has no effect$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: assignment from incompatible pointer type$'; FileName: 1; Line: 2; Column: 0),
{110} (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: initializer-string for array of chars is too long$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+): no resources$'; FileName: 1; Line: 0; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: invalid application of ''(.*)'' to incomplete type ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: void value not ignored as it ought to be$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^Creating library file: (.*)$'; FileName: 1; Line: 0; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: useless type name in empty declaration$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: unknown conversion type character ''(.*)'' in format$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: parameter name omitted$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: expected declaration specifiers before ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: old-style parameter declarations in prototyped function definition$'; FileName: 1; Line: 2; Column: 0),
{120} (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: empty declaration$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: expected declaration specifiers before ''(.*)'' token$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: expected declaration specifiers or ''(.*)'' before ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: storage class specified for parameter ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: duplicate member ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: expected ''(.*)'' before string constant$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: called object ''(.*)'' is not a function$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): Error: too many memory references for `(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: excess elements in array initializer$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: size of array ''(.*)'' is too large$'; FileName: 1; Line: 2; Column: 0),
{130} (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: incompatible types when assigning to type ''(.*)'' from type ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: invalid operands to binary (.*) \(have ''(.*)'' and ''(.*)''\)$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: assuming signed overflow does not occur when assuming that (.*) is always (.*)$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):(.*):\((.*)\): more undefined references to `(.*)'' follow$'; FileName: 1; Line: 0; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: extended initializer lists only available with (.*) or (.*)$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: type of formal parameter ([0-9]+) is incomplete$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: dereferencing ''(.*)'' pointer$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: request for member ''(.*)'' in something not a structure or union$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: conflicting types for ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): note: previous definition of ''(.*)'' was here$'; FileName: 1; Line: 2; Column: 0),
{140} (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: useless storage class specifier in empty declaration$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: ''(.*)'' was ignored in this declaration$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: overflow in array dimension$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: dereferencing pointer to incomplete type$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: no matching function for call to ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): note: candidates are: (.*)$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: declaration of ''(.*)'' shadows a parameter$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: within this context$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): note: previous declaration of ''(.*)'' was here$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: return-statement with a value, in function returning ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
{150} (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: passing ''(.*)'' as ''(.*)'' argument of ''(.*)'' discards qualifiers$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: template argument ([0-9]+) is invalid$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: expected unqualified-id before ''(.*)'' token$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: return type of ''(.*)'' is not ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: ''(.*)'' with a value, in function returning void$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: ''(.*)'' with no value, in function returning non-void$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: redefinition of ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+):([0-9]+): warning: integer constant is so large that it is unsigned$'; FileName: 1; Line: 2; Column: 3),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: ''(.*)'' or ''(.*)'' invalid for ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: variable or field ''(.*)'' declared void$'; FileName: 1; Line: 2; Column: 0),
{160} (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: expected primary-expression before ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: redeclaration of ''(.*)'' with no linkage$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):(.*):\(.*?\+0x[0-9A-Fa-f]+\): undefined reference to `(.*)''$'; FileName: 2; Line: 0; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+): cannot open output file (.*): Permission denied$'; FileName: 2; Line: 0; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+):([0-9]+): error: too many decimal points in number$'; FileName: 1; Line: 2; Column: 3),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+):([0-9]+): warning: assignment makes integer from pointer without a cast [enabled by default]$'; FileName: 1; Line: 2; Column: 3),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+):([0-9]+): error: lvalue required as unary ''(.*)'' operand$'; FileName: 1; Line: 2; Column: 3),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: ''(.*)'' loop initial declarations are only allowed in (.*) mode$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): note: use option (.*) or (.*) to compile your code$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+):([0-9]+): fatal error: (.*): No such file or directory$'; FileName: 1; Line: 2; Column: 3),
{170} (Expression: '^compilation terminated\.$'; FileName: 0; Line: 0; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+):([0-9]+): warning: no newline at end of file$'; FileName: 1; Line: 2; Column: 3),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: ''(.*)'' previously defined here$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: invalid use of ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: expected declaration before ''(.*)'' token$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: ''(.*)'' defined but not used$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: variable-sized object may not be initialized$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+):([0-9]+): warning: this is the location of the previous definition$'; FileName: 1; Line: 2; Column: 3),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: friend declaration ''(.*)'' declares a non-template function$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): note: \(if this is not what you intended, make sure the function template has already been declared and add <> after the function name here\) $'; FileName: 1; Line: 2; Column: 0),
{180} (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: ''(.*)'' has not been declared$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: ''(.*)'' is an inaccessible base of ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+): In function `(.*)'':$'; FileName: 1; Line: 0; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: `(.*)'' was not declared in this scope$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: expected `(.*)'' before "(.*)"$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: extra qualification ''(.*)'' on member ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): error: initializer element is not constant$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): warning: conflicting types for ''(.*)''$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+):([0-9]+): note: previous implicit declaration of ''(.*)'' was here$'; FileName: 1; Line: 2; Column: 0),
      (Expression: '^([a-zA-Z]?:?[^:]+): At top level:$'; FileName: 1; Line: 0; Column: 0)
  );

type
  TLanguageProperty = class
    ID: Cardinal;
      Name: string;
    ImageIndex: TImageIndex;
    Version: string;
    Translator: string;
    Email: string;
  end;

  TFalconLanguages = class
  private
    FList: TStrings;
    FDefault: Boolean;
    FLangDir: string;
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
    function UpdateLang(LangName: string): Boolean;
    function GetLangByID(LangID: Word): string;
    function GetImageIndexByID(LangID: Word): Integer;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TLanguageProperty read GetItem;
  public
    property LangDir: string read FLangDir write FLangDir;
    property LangDefault: Boolean read FDefault write SetLangDefault;
    property Current: TLanguageProperty read FCurrent write FCurrent;
  end;

var
  //STR_OTHERS: array[1..300] of String;

  STR_MENUS: array[1..MAX_MENUS] of string;
  STR_MENU_FILE: array[1..MAX_MENU_FILE] of string;
  STR_MENU_EDIT: array[1..MAX_MENU_EDIT] of string;
  STR_MENU_SERH: array[1..MAX_MENU_SERH] of string;
  STR_MENU_VIEW: array[1..MAX_MENU_VIEW] of string;
  STR_MENU_PROJ: array[1..MAX_MENU_PROJ] of string;
  STR_MENU_RUN: array[1..MAX_MENU_RUN] of string;
  STR_MENU_TOOL: array[1..MAX_MENU_TOOL] of string;
  STR_MENU_HELP: array[1..MAX_MENU_HELP] of string;
  STR_NEW_MENU: array[1..MAX_NEW_MENU] of string;
  STR_IMPORT_MENU: array[1..MAX_IMPORT_MENU] of string;
  STR_VIEWTOOLBAR_MENU: array[1..MAX_VIEWTOOLBAR_MENU] of string;

  STR_DEFAULTBAR: array[1..MAX_DEFAULTBAR] of string;
  STR_EDITBAR: array[1..MAX_EDITBAR] of string;
  STR_SEARCHBAR: array[1..MAX_SEARCHBAR] of string;
  STR_COMPILERBAR: array[1..MAX_COMPILERBAR] of string;
  STR_NAVIGATORBAR: array[1..MAX_NAVIGATORBAR] of string;
  STR_PROJECTBAR: array[1..MAX_PROJECTBAR] of string;
  STR_HELPBAR: array[1..MAX_HELPBAR] of string;
  STR_DEBUGBAR: array[1..MAX_DEBUGBAR] of string;

  STR_POPUP_PROJ: array[1..MAX_POPUP_PROJ] of string;
  STR_POPUP_EDITOR: array[1..MAX_POPUP_EDITOR] of string;
  STR_POPUP_TABS: array[1..MAX_POPUP_TABS] of string;
  STR_POPUP_MSGS: array[1..MAX_POPUP_MSGS] of string;

  STR_FRM_MAIN: array[1..MAX_FRM_MAIN] of string;
  STR_FRM_PROP: array[1..MAX_FRM_PROP] of string;
  STR_FRM_NEW_PROJ: array[1..MAX_FRM_NEW_PROJ] of string;
  STR_CMPMSG: array[1..MAX_CMPMSG] of string;
  STR_FRM_UPD: array[1..MAX_FRM_UPD] of string;
  STR_FRM_FIND: array[1..MAX_FRM_FIND] of string;
  STR_FRM_EDITOR_OPT: array[1..MAX_FRM_EDITOR_OPT] of string;
  STR_FRM_ENV_OPT: array[1..MAX_FRM_ENV_OPT] of string;
  STR_FRM_CODE_TEMPL: array[1..MAX_FRM_CODE_TEMPL] of string;
  STR_FRM_PROMPT_CODE: array[1..MAX_FRM_PROMPT_CODE] of string;
  STR_FRM_ABOUT: array[1..MAX_FRM_ABOUT] of string;
  STR_FRM_GOTOLINE: array[1..MAX_FRM_GOTOLINE] of string;
  STR_FRM_GOTOFUNC: array[1..MAX_FRM_GOTOFUNC] of string;

implementation

uses UUtils, UFrmOptions, UFrmUpdate, UFrmMain,
  UFrmCompOptions, UFrmEditorOptions, UFrmEnvOptions, SystemUtils, UnicodeUtils;

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
    FList.Objects[0].Free; //English
  FList.Free;
  inherited Destroy;
end;

function TFalconLanguages.GetItem(Index: Integer): TLanguageProperty;
begin
  Result := nil;
  if (Index < 0) or (Index >= FList.Count) then
    Exit;
  Result := TLanguageProperty(FList.Objects[Index]);
end;

function TFalconLanguages.GetCount: Integer;
begin
  Result := FList.Count;
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
    for I := 1 to MAX_NEW_MENU do
      STR_NEW_MENU[I] := CONST_STR_NEW_MENU[I];
    for I := 1 to MAX_IMPORT_MENU do
      STR_IMPORT_MENU[I] := CONST_STR_IMPORT_MENU[I];
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
    for I := 1 to MAX_POPUP_MSGS do
      STR_POPUP_MSGS[I] := CONST_STR_POPUP_MSGS[I];

    for I := 1 to MAX_FRM_MAIN do
      STR_FRM_MAIN[I] := CONST_STR_FRM_MAIN[I];
    for I := 1 to MAX_FRM_PROP do
      STR_FRM_PROP[I] := CONST_STR_FRM_PROP[I];
    for I := 1 to MAX_FRM_NEW_PROJ do
      STR_FRM_NEW_PROJ[I] := CONST_STR_FRM_NEW_PROJ[I];
    for I := 1 to MAX_CMPMSG do
      STR_CMPMSG[I] := ''{CONST_STR_CMPMSG[I].Expression};
    for I := 1 to MAX_FRM_UPD do
      STR_FRM_UPD[I] := CONST_STR_FRM_UPD[I];
    for I := 1 to MAX_FRM_FIND do
      STR_FRM_FIND[I] := CONST_STR_FRM_FIND[I];
    for I := 1 to MAX_FRM_EDITOR_OPT do
      STR_FRM_EDITOR_OPT[I] := CONST_STR_FRM_EDITOR_OPT[I];
    for I := 1 to MAX_FRM_ENV_OPT do
      STR_FRM_ENV_OPT[I] := CONST_STR_FRM_ENV_OPT[I];
    for I := 1 to MAX_FRM_CODE_TEMPL do
      STR_FRM_CODE_TEMPL[I] := CONST_STR_FRM_CODE_TEMPL[I];
    for I := 1 to MAX_FRM_PROMPT_CODE do
      STR_FRM_PROMPT_CODE[I] := CONST_STR_FRM_PROMPT_CODE[I];
    for I := 1 to MAX_FRM_ABOUT do
      STR_FRM_ABOUT[I] := CONST_STR_FRM_ABOUT[I];
    for I := 1 to MAX_FRM_GOTOLINE do
      STR_FRM_GOTOLINE[I] := CONST_STR_FRM_GOTOLINE[I];
    for I := 1 to MAX_FRM_GOTOFUNC do
      STR_FRM_GOTOFUNC[I] := CONST_STR_FRM_GOTOFUNC[I];
  end;
  FDefault := Value;
end;

function TFalconLanguages.GetLangByID(LangID: Word): string;
var
  LangItem: TLanguageProperty;
  I: Integer;
begin
  Result := '';
  for I := 0 to FList.Count - 1 do
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
  for I := 0 to FList.Count - 1 do
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
  Temp: string;
  I: Integer;
  SaveID: Cardinal;
  ini: TMemIniFile;
  Lines: TStrings;
begin
  Files := TStringList.Create;
  SaveID := FCurrent.ID;
  Clear;
  Lines := TStringList.Create;
  FindFiles(LangDir + '*.lng', Files);
  for I := 0 to Files.Count - 1 do
  begin
    Temp := LangDir + Files.Strings[I];
    ini := TMemIniFile.Create('');
    try
      LoadFileEx(Temp, Lines);
      ini.SetStrings(Lines);
    except
      Continue;
    end;
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
  Lines.Free;
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

function TFalconLanguages.UpdateLang(LangName: string): Boolean;
var
  LangProp: TLanguageProperty;
  Temp: string;
  I: Integer;
  ini: TMemIniFile;

  function ReadStr(const Ident: Integer; const Default: string): string;
  begin
    Result := ini.ReadString('FALCON', IntToStr(Ident), Default);
  end;

var
  Lines: TStrings;
begin
  Result := False;
  Temp := '';
  { Find language name }
  for I := 0 to FList.Count - 1 do
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
  Lines := TStringList.Create;
  ini := TMemIniFile.Create('');
  try
    LoadFileEx(Temp, Lines);
    ini.SetStrings(Lines);
  except
  end;
  Lines.Free;
  for I := 1 to MAX_MENUS do //1
    STR_MENUS[I] := ReadStr(I, CONST_STR_MENUS[I]);
  for I := 1 to MAX_MENU_FILE do //109
    STR_MENU_FILE[I] := ReadStr(I + 108, CONST_STR_MENU_FILE[I]);
  for I := 1 to MAX_MENU_EDIT do //221
    STR_MENU_EDIT[I] := ReadStr(I + 220, CONST_STR_MENU_EDIT[I]);
  for I := 1 to MAX_MENU_SERH do //334
    STR_MENU_SERH[I] := ReadStr(I + 333, CONST_STR_MENU_SERH[I]);
  for I := 1 to MAX_MENU_VIEW do //391
    STR_MENU_VIEW[I] := ReadStr(I + 390, CONST_STR_MENU_VIEW[I]);
  for I := 1 to MAX_MENU_PROJ do //435
    STR_MENU_PROJ[I] := ReadStr(I + 434, CONST_STR_MENU_PROJ[I]);
  for I := 1 to MAX_MENU_RUN do //541
    STR_MENU_RUN[I] := ReadStr(I + 540, CONST_STR_MENU_RUN[I]);
  for I := 1 to MAX_MENU_TOOL do //646
    STR_MENU_TOOL[I] := ReadStr(I + 645, CONST_STR_MENU_TOOL[I]);
  for I := 1 to MAX_MENU_HELP do //854
    STR_MENU_HELP[I] := ReadStr(I + 853, CONST_STR_MENU_HELP[I]);


  for I := 1 to MAX_NEW_MENU do //959
    STR_NEW_MENU[I] := ReadStr(I + 958, CONST_STR_NEW_MENU[I]);
  for I := 1 to MAX_IMPORT_MENU do //970
    STR_IMPORT_MENU[I] := ReadStr(I + 969, CONST_STR_IMPORT_MENU[I]);

  for I := 1 to MAX_VIEWTOOLBAR_MENU do //978
    STR_VIEWTOOLBAR_MENU[I] := ReadStr(I + 977, CONST_STR_VIEWTOOLBAR_MENU[I]);

  for I := 1 to MAX_DEFAULTBAR do //1067
    STR_DEFAULTBAR[I] := ReadStr(I + 1066, CONST_STR_DEFAULTBAR[I]);
  for I := 1 to MAX_EDITBAR do //1080
    STR_EDITBAR[I] := ReadStr(I + 1079, CONST_STR_EDITBAR[I]);
  for I := 1 to MAX_SEARCHBAR do //1138
    STR_SEARCHBAR[I] := ReadStr(I + 1137, CONST_STR_SEARCHBAR[I]);
  for I := 1 to MAX_COMPILERBAR do //1098
    STR_COMPILERBAR[I] := ReadStr(I + 1097, CONST_STR_COMPILERBAR[I]);
  for I := 1 to MAX_NAVIGATORBAR do //1089
    STR_NAVIGATORBAR[I] := ReadStr(I + 1088, CONST_STR_NAVIGATORBAR[I]);
  for I := 1 to MAX_PROJECTBAR do //1119
    STR_PROJECTBAR[I] := ReadStr(I + 1118, CONST_STR_PROJECTBAR[I]);
  for I := 1 to MAX_HELPBAR do //1110
    STR_HELPBAR[I] := ReadStr(I + 1109, CONST_STR_HELPBAR[I]);
  for I := 1 to MAX_DEBUGBAR do //1128
    STR_DEBUGBAR[I] := ReadStr(I + 1127, CONST_STR_DEBUGBAR[I]);

  for I := 1 to MAX_POPUP_PROJ do //1181
    STR_POPUP_PROJ[I] := ReadStr(I + 1180, CONST_STR_POPUP_PROJ[I]);
  for I := 1 to MAX_POPUP_EDITOR do //1291
    STR_POPUP_EDITOR[I] := ReadStr(I + 1290, CONST_STR_POPUP_EDITOR[I]);
  for I := 1 to MAX_POPUP_TABS do //1351
    STR_POPUP_TABS[I] := ReadStr(I + 1350, CONST_STR_POPUP_TABS[I]);
  for I := 1 to MAX_POPUP_MSGS do //1375
    STR_POPUP_MSGS[I] := ReadStr(I + 1374, CONST_STR_POPUP_MSGS[I]);

  for I := 1 to MAX_FRM_MAIN do //1405
    STR_FRM_MAIN[I] := ReadStr(I + 1404, CONST_STR_FRM_MAIN[I]);
  STR_FRM_MAIN[49] := StringReplace(STR_FRM_MAIN[49], '\n', #13, [rfReplaceAll]);
  STR_FRM_MAIN[54] := StringReplace(STR_FRM_MAIN[54], '\n', #13, [rfReplaceAll]);

  for I := 1 to MAX_FRM_PROP do //1528
    STR_FRM_PROP[I] := ReadStr(I + 1527, CONST_STR_FRM_PROP[I]);
  for I := 1 to MAX_FRM_NEW_PROJ do //1673
    STR_FRM_NEW_PROJ[I] := ReadStr(I + 1672, CONST_STR_FRM_NEW_PROJ[I]);
  for I := 1 to MAX_CMPMSG do //1785
    STR_CMPMSG[I] := ReadStr(I + 1784, ''{CONST_STR_CMPMSG[I].Expression});
  for I := 1 to MAX_FRM_UPD do //4001
    STR_FRM_UPD[I] := ReadStr(I + 4000, CONST_STR_FRM_UPD[I]);
  for I := 1 to MAX_FRM_FIND do //4201
    STR_FRM_FIND[I] := ReadStr(I + 4200, CONST_STR_FRM_FIND[I]);
  STR_FRM_FIND[30] := StringReplace(STR_FRM_FIND[30], '\n', #13, [rfReplaceAll]);
  for I := 1 to MAX_FRM_EDITOR_OPT do //4333
    STR_FRM_EDITOR_OPT[I] := TranslateSpecialChars(ReadStr(I + 4332, CONST_STR_FRM_EDITOR_OPT[I]));
  for I := 1 to MAX_FRM_ENV_OPT do //4569
    STR_FRM_ENV_OPT[I] := ReadStr(I + 4568, CONST_STR_FRM_ENV_OPT[I]);
  for I := 1 to MAX_FRM_CODE_TEMPL do //4704
    STR_FRM_CODE_TEMPL[I] := ReadStr(I + 4703, CONST_STR_FRM_CODE_TEMPL[I]);
  for I := 1 to MAX_FRM_PROMPT_CODE do //4808
    STR_FRM_PROMPT_CODE[I] := ReadStr(I + 4807, CONST_STR_FRM_PROMPT_CODE[I]);
  for I := 1 to MAX_FRM_ABOUT do //4909
    STR_FRM_ABOUT[I] := ReadStr(I + 4908, CONST_STR_FRM_ABOUT[I]);
  for I := 1 to MAX_FRM_GOTOLINE do //5015
    STR_FRM_GOTOLINE[I] := ReadStr(I + 5014, CONST_STR_FRM_GOTOLINE[I]);
  for I := 1 to MAX_FRM_GOTOFUNC do //5117
    STR_FRM_GOTOFUNC[I] := ReadStr(I + 5116, CONST_STR_FRM_GOTOFUNC[I]);

  ini.Free;
  UpdateForms;
end;

end.
