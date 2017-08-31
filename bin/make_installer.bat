@ECHO OFF
call copy_files
call reduce_size
"%ProgramFiles(x86)%\NSIS\makensis" "..\src\installer\Falcon C++.nsi"
if not %ERRORLEVEL% == 0 pause > NUL
"%ProgramFiles(x86)%\NSIS\makensis" /DWin64 "..\src\installer\Falcon C++.nsi"
if not %ERRORLEVEL% == 0 pause > NUL
"%ProgramFiles(x86)%\NSIS\makensis" /DWITH_MINGW "..\src\installer\Falcon C++.nsi"
if not %ERRORLEVEL% == 0 pause > NUL
"%ProgramFiles(x86)%\NSIS\makensis" /DWin64 /DWITH_MINGW "..\src\installer\Falcon C++.nsi"
if not %ERRORLEVEL% == 0 pause > NUL
