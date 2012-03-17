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

  MAX_MENU_HELP = 6;
  CONST_STR_MENU_HELP: array[1..MAX_MENU_HELP] of String = (
  //Help Menu
    'Falcon Help',
    'Tip of the Day...',
    '',
    'Update',
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

  MAX_IMPORT_MENU = 3;
  CONST_STR_IMPORT_MENU: array[1..MAX_IMPORT_MENU] of String  = (
  //Import From Menu File
    'Dev-C++ Project',
    'Code::Blocks Project',
    'MS Visual C++ Project'
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

  MAX_POPUP_MSGS = 7;
  CONST_STR_POPUP_MSGS: array[1..MAX_POPUP_MSGS] of String  = (
  //PopupMenu from Messages
    'Copy',
    'Copy original message',
    '',
    'Original message',
    '',
    'Goto line',
    'Clear'
  );
  
  MAX_FRM_MAIN = 50;
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
    'Loading configurations...',
    'Compiler was not detected!',
    'Can''t import %s project!',
    '%s Project',
    'This file has been modified by another program.'#13 +
      'Do you want to reload it?',
    'Variables'
  );

  MAX_FRM_PROP = 70;
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
    'Select folder to include',
    'Edit selected'
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

  MAX_FRM_FIND = 34;
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
    'Find ''%s'' in file ''%s''',
    'Found ''%s'' in line %d, column %d'
  );

  MAX_FRM_EDITOR_OPT = 137;
  CONST_STR_FRM_EDITOR_OPT: array[1..MAX_FRM_EDITOR_OPT] of String  = (
    'Editor Options',
  //General Sheet
    'General',
    'Editor Options',
    'Auto Indent',
    '',
    'Insert Mode',
    'Group Undo',
    'Keep Trailing Spaces',
    'Show Line Characters',
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
    'Pad empty lines around header blocks (e.g. ''if'', ''for'', ''while''...).'+
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
    'Edit'
  );

  MAX_FRM_ENV_OPT = 36;
  CONST_STR_FRM_ENV_OPT: array[1..MAX_FRM_ENV_OPT] of String  = (
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
    'Restart application to apply changes',
    'Configuration files'
  );

  MAX_FRM_CODE_TEMPL = 6;
  CONST_STR_FRM_CODE_TEMPL: array[1..MAX_FRM_CODE_TEMPL] of String  = (
    'Templates',
    'Code',
    'Invalid Name!',
    'Name already exist',
    'Add Code Template',
    'Edit Code Template'
  );

  MAX_FRM_PROMPT_CODE = 2;
  CONST_STR_FRM_PROMPT_CODE: array[1..MAX_FRM_PROMPT_CODE] of String  = (
    'Name',
    'Description'
  );

  MAX_FRM_ABOUT = 6;
  CONST_STR_FRM_ABOUT: array[1..MAX_FRM_ABOUT] of String  = (
    'About',
    'Compatibility: %s',
    'Licence',
    'Developers',
    'Translators',
    'Testers'
  );

  MAX_FRM_GOTOLINE = 2;
  CONST_STR_FRM_GOTOLINE: array[1..MAX_FRM_GOTOLINE] of String  = (
    'Goto Line',
    'Line (%d - %d):'
  );

  MAX_FRM_GOTOFUNC = 6;
  CONST_STR_FRM_GOTOFUNC: array[1..MAX_FRM_GOTOFUNC] of String  = (
    'Goto Function',
    'Function name',
    'Name',
    'Return type',
    'Line',
    'File'
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
  STR_IMPORT_MENU: array[1..MAX_IMPORT_MENU] of String;
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
  STR_POPUP_MSGS: array[1..MAX_POPUP_MSGS] of String;

  STR_FRM_MAIN: array[1..MAX_FRM_MAIN] of String;
  STR_FRM_PROP: array[1..MAX_FRM_PROP] of String;
  STR_FRM_NEW_PROJ: array[1..MAX_FRM_NEW_PROJ] of String;
  STR_CMPMSG: array[1..MAX_CMPMSG] of String;
  STR_FRM_UPD: array[1..MAX_FRM_UPD] of String;
  STR_FRM_FIND: array[1..MAX_FRM_FIND] of String;
  STR_FRM_EDITOR_OPT: array[1..MAX_FRM_EDITOR_OPT] of String;
  STR_FRM_ENV_OPT: array[1..MAX_FRM_ENV_OPT] of String;
  STR_FRM_CODE_TEMPL: array[1..MAX_FRM_CODE_TEMPL] of String;
  STR_FRM_PROMPT_CODE: array[1..MAX_FRM_PROMPT_CODE] of String;
  STR_FRM_ABOUT: array[1..MAX_FRM_ABOUT] of String;
  STR_FRM_GOTOLINE: array[1..MAX_FRM_GOTOLINE] of String;
  STR_FRM_GOTOFUNC: array[1..MAX_FRM_GOTOFUNC] of String;

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
    //sub menu import
    for I := 1 to MAX_IMPORT_MENU do
      STR_IMPORT_MENU[I] := CONST_STR_IMPORT_MENU[I];
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
    for I := 1 to MAX_POPUP_MSGS do
      STR_POPUP_MSGS[I] := CONST_STR_POPUP_MSGS[I];

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
  for I := 1 to MAX_IMPORT_MENU do//970
    STR_IMPORT_MENU[I] := ReadStr(I + 969, CONST_STR_IMPORT_MENU[I]);

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
  for I := 1 to MAX_POPUP_MSGS do//1375
    STR_POPUP_MSGS[I] := ReadStr(I + 1374, CONST_STR_POPUP_MSGS[I]);

  for I := 1 to MAX_FRM_MAIN do//1405
    STR_FRM_MAIN[I] := ReadStr(I + 1404, CONST_STR_FRM_MAIN[I]);
  STR_FRM_MAIN[49] := StringReplace(STR_FRM_MAIN[49], '\n', #13, [rfReplaceAll]);

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
  for I := 1 to MAX_FRM_EDITOR_OPT do//4333
  begin
    STR_FRM_EDITOR_OPT[I] := ReadStr(I + 4332, CONST_STR_FRM_EDITOR_OPT[I]);
    STR_FRM_EDITOR_OPT[I] := StringReplace(STR_FRM_EDITOR_OPT[I], '\n', #13,
      [rfReplaceAll]);
  end;
  for I := 1 to MAX_FRM_ENV_OPT do//4569
    STR_FRM_ENV_OPT[I] := ReadStr(I + 4568, CONST_STR_FRM_ENV_OPT[I]);
  for I := 1 to MAX_FRM_CODE_TEMPL do//4704
    STR_FRM_CODE_TEMPL[I] := ReadStr(I + 4703, CONST_STR_FRM_CODE_TEMPL[I]);
  for I := 1 to MAX_FRM_PROMPT_CODE do//4808
    STR_FRM_PROMPT_CODE[I] := ReadStr(I + 4807, CONST_STR_FRM_PROMPT_CODE[I]);
  for I := 1 to MAX_FRM_ABOUT do//4909
    STR_FRM_ABOUT[I] := ReadStr(I + 4908, CONST_STR_FRM_ABOUT[I]);
  for I := 1 to MAX_FRM_GOTOLINE do//5015
    STR_FRM_GOTOLINE[I] := ReadStr(I + 5014, CONST_STR_FRM_GOTOLINE[I]);
  for I := 1 to MAX_FRM_GOTOFUNC do//5117
    STR_FRM_GOTOFUNC[I] := ReadStr(I + 5116, CONST_STR_FRM_GOTOFUNC[I]);
  //end
  ini.Free;
  UpdateForms;
end;

end.
