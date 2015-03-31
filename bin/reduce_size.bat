@ECHO OFF
upx --all-methods --compress-icons=0 x86\Falcon.exe
SET ERROR=%ERRORLEVEL%
if %ERRORLEVEL% == 2 SET ERROR=0
if not %ERROR% == 0 pause > NUL
upx --all-methods --compress-icons=0 x86\PkgManager.exe
SET ERROR=%ERRORLEVEL%
if %ERRORLEVEL% == 2 SET ERROR=0
if not %ERROR% == 0 pause > NUL
upx --all-methods --compress-icons=0 x86\Updater.exe
SET ERROR=%ERRORLEVEL%
if %ERRORLEVEL% == 2 SET ERROR=0
if not %ERROR% == 0 pause > NUL
upx --all-methods --compress-icons=0 x86\AStyle.dll
SET ERROR=%ERRORLEVEL%
if %ERRORLEVEL% == 2 SET ERROR=0
if not %ERROR% == 0 pause > NUL

upx --all-methods --compress-icons=0 x64\Falcon.exe
SET ERROR=%ERRORLEVEL%
if %ERRORLEVEL% == 2 SET ERROR=0
if not %ERROR% == 0 pause > NUL
upx --all-methods --compress-icons=0 x64\PkgManager.exe
SET ERROR=%ERRORLEVEL%
if %ERRORLEVEL% == 2 SET ERROR=0
if not %ERROR% == 0 pause > NUL
upx --all-methods --compress-icons=0 x64\Updater.exe
SET ERROR=%ERRORLEVEL%
if %ERRORLEVEL% == 2 SET ERROR=0
if not %ERROR% == 0 pause > NUL
upx --all-methods --compress-icons=0 x64\AStyle.dll
SET ERROR=%ERRORLEVEL%
if %ERRORLEVEL% == 2 SET ERROR=0
if not %ERROR% == 0 pause > NUL
