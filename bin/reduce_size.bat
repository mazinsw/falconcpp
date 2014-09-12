@ECHO OFF
upx --all-methods --compress-icons=0 Falcon.exe
upx --all-methods --compress-icons=0 PkgManager.exe
upx --all-methods --compress-icons=0 PkgManager_no_adm.exe
upx --all-methods --compress-icons=0 PkgEditor.exe
upx --all-methods --compress-icons=0 Updater.exe
upx --all-methods --compress-icons=0 AStyle.dll
if %ERRORLEVEL% == 2 goto fim
if not %ERRORLEVEL% == 0 pause > NUL
:fim