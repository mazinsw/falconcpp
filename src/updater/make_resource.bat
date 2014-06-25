@ECHO OFF
brcc32 "%~dp0resources.rc"
if not %errorlevel%==0 pause > NUL
brcc32 "%~dp0resources_portable.rc" -DFALCON_PORTABLE
if not %errorlevel%==0 pause > NUL