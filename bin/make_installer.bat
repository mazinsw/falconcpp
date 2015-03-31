@ECHO OFF
call reduce_size
"%ProgramFiles(x86)%\NSIS\makensis" /DARCH=x86 /DARCH_NAME=Win32 "..\src\installer\Falcon C++.nsi"
if not %ERRORLEVEL% == 0 pause > NUL
"%ProgramFiles(x86)%\NSIS\makensis" /DARCH=x86 /DARCH_NAME=Win32 /DWITH_MINGW "..\src\installer\Falcon C++.nsi"
if not %ERRORLEVEL% == 0 pause > NUL
"%ProgramFiles(x86)%\NSIS\makensis" /DARCH=x64 /DARCH_NAME=Win64 "..\src\installer\Falcon C++.nsi"
if not %ERRORLEVEL% == 0 pause > NUL
"%ProgramFiles(x86)%\NSIS\makensis" /DARCH=x64 /DARCH_NAME=Win64 /DWITH_MINGW "..\src\installer\Falcon C++.nsi"
if not %ERRORLEVEL% == 0 pause > NUL
