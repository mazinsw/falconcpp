unit DebugConsts;

interface

const
  GDB_PROMPT = '(gdb)';
  GDB_RUN = 'run';
  GDB_EXECFILE = 'exec-file';
  GDB_FILE = 'file';
  GDB_RECORD = 'record';
  GDB_PRINT = 'print';
  GDB_DELETE = 'delete';
  GDB_NEXT = 'next';
  GDB_STEP = 'step';
  GDB_BREAK = 'break';
  GDB_FINISH = 'finish';
  GDB_CONTINUE = 'continue';
  GDB_REVERSE = 'reverse';
  GDB_QUIT = 'quit';
  GDB_DISPLAY = 'display';
  GDB_SETARGS = 'set args';
  GDB_INFO = 'info';
  GDB_OFF = 'off';
  GDB_ON = 'on';
  GDB_SET = 'set';
  GDB_SETWIDTH = 'set width';
  GDB_SETHEIGHT = 'set height';
  GDB_SETCONFIRM = 'set confirm';
  GDB_SETNEWCONSOLE = 'set new-console';
  GDB_SETPRINTADDR = 'set print address';
  GDB_SETPRINTSYMBOL = 'set print symbol-filename';
  GDB_SETPRINTNULLSTOP = 'set print null-stop';
  GDB_WATCH = 'watch';

  CR = #13;
  LF = #10;

  dbgLetterChars: set of AnsiChar = ['A'..'Z', 'a'..'z', '_'];
  dbgDigitChars: set of AnsiChar = ['0'..'9'];
  dbgHexChars: set of AnsiChar = ['A'..'F', 'a'..'f'];
  dbgSpaceChars: set of AnsiChar = [' ', #9];
  dbgLineChars: set of AnsiChar = [#13, #10];
  dbgArithmChars: set of AnsiChar = ['.', '+', '-', '*', '/', '%'];
  dbgBraceChars: set of AnsiChar = ['(', ')', '{', '}', '<', '>', '[', ']'];

  REGEXP_PROMPT = '(gdb)';
  REGEXP_PRINT = '\$([0-9]+) = (.*)';
  //5: messages = {hwnd = 0x401850, message = 2359024}
  REGEXP_DISPLAY = '([0-9]+): ([^ ]+) = (.*)';
  //main (argc=3, argv=0x324a8) at main.cpp:29
  REGEXP_LOCALIZE = '(.*) [(].*[)] at (.*):([0-9]+)';
  //Breakpoint 1, main (argc=3, argv=) at main.cpp:28
  REGEXP_ONBREAK = 'Breakpoint ([0-9]+), (.*) [(].*[)] at (.*):([0-9]+)';
  //28	    a.SetIdade(13);, Line: 1
  //REGEXP_NEXTLINE   = '([0-9]+)[\t].*';
  //#26#26D:\Estudos\Delphi 7\MZSW\Falcon C++\src\debug/main.cpp:28:1001:beg:0x4013a4
  REGEXP_NEXTLINE = '\x1A\x1A([A-Za-z]:)([^:]+):([0-9]+):[0-9]+:[beg]+:(0x[0-9A-Fa-f]+)';
  //Breakpoint 1 at 0x40133d: file main.cpp, line 27
  REGEXP_BREAKPOINT = 'Breakpoint ([0-9]+) at [xA-Fa-f0-9]+: file (.*), line ([0-9]+).';
  //[New thread 3588.0xdf4]
  REGEXP_NEWTHREAD = '[[]New [tT]hread ([xA-Fa-f0-9]+).([xA-Fa-f0-9]+)[]]';
  //No symbol "novaidade" in current context.
  REGEXP_NOSYMBOL = 'No symbol ["](.*)["] in current context.';
  //Program exited normally.
  REGEXP_TERMINATE = 'Program exited normally.';
  //[Inferior 1 (process 5220) exited normally]
  REGEXP_TERMINATENORM = '[[]Inferior [0-9]+ [(]process [0-9]+[)] exited normally[]]';
  //Program exited with code 1156545.
  REGEXP_TERMINATECODE = 'Program exited with code ([xA-Fa-f0-9]+).';
  //[Inferior 1 (process 5220) exited with code 01]
  REGEXP_PROCESSEXITED = '[[]Inferior [0-9]+ [(]process [0-9]+[)] exited with code ([0-9]+)[]]';
  //Current language:  auto; currently c++
  REGEXP_LANGUAGE = 'Current language:  (.*); currently (.*)';
  //0x77d28709 in USER32!GetDC () from C:\WINDOWS\system32\user32.dll
  REGEXP_EXTERNALSTEP = '0x[0-9A-z]+ in ([^\(]+) \(\) from (.*)';
  //0x004010b6 in __mingw_CRTStartup ()
  REGEXP_EXITING = '(0x[0-9A-z]+) in (.*) ()';
  //Hardware watchpoint 2: hInst
  REGEXP_ONADDWATCH = 'Hardware watchpoint ([0-9]+): (.*)';
  //Watchpoint 6: messages
  REGEXP_ONWATCHPOINT = 'Watchpoint ([0-9]+): (.*)';

implementation

end.
