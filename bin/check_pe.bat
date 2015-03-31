@echo off

ECHO Checking x64 files
petype.pl x64\AStyle.dll
petype.pl x64\ConsoleRunner.exe
petype.pl x64\Falcon.exe
petype.pl x64\PkgManager.exe
petype.pl x64\SciLexer.dll
petype.pl x64\Updater.exe
petype.pl ..\res\plugin\x64\NSIS_EnvSet.dll
ECHO.
ECHO Checking x86 files
petype.pl x86\AStyle.dll
petype.pl x86\ConsoleRunner.exe
petype.pl x86\Falcon.exe
petype.pl x86\PkgManager.exe
petype.pl x86\SciLexer.dll
petype.pl x86\Updater.exe
petype.pl ..\res\plugin\x86\NSIS_EnvSet.dll
pause > NUL