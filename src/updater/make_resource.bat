@ECHO OFF
brcc32 "%~dp0resources.rc"
if not %errorlevel%==0 pause > NUL