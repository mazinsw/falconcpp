@ECHO OFF
echo Compiling Help File
"C:\Program Files\HTML Help Workshop\hhc.exe" "falcon.hhp"
if not %ERRORLEVEL% == 1 pause > NUL