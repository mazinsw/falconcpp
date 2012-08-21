@ECHO OFF
call reduce_size
"%PROGRAMFILES%\NSIS\makensis" "..\src\installer\Falcon C++.nsi"
if not %ERRORLEVEL% == 0 pause > NUL
"%PROGRAMFILES%\NSIS\makensis" /DWITH_MINGW "..\src\installer\Falcon C++.nsi"
if not %ERRORLEVEL% == 0 pause > NUL