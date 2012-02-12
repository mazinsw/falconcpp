@ECHO OFF
call reduce_size
makensis "..\src\installer\Falcon C++.nsi"
if not %ERRORLEVEL% == 0 pause > NUL
makensis /DWITH_MINGW "..\src\installer\Falcon C++.nsi"
if not %ERRORLEVEL% == 0 pause > NUL