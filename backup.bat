@echo OFF 
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
For /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a-%%b)
SET filename="%~d0%~p0backup\Falcon C++ %mydate%_%mytime%.7z"
call src/clean
call res/clean
"%programfiles%\7-zip\7z" a -r %filename% src
"%programfiles%\7-zip\7z" a -r %filename% tests
"%programfiles%\7-zip\7z" a -r %filename% bin\make_installer.bat
"%programfiles%\7-zip\7z" a -r %filename% bin\reduce_size.bat
"%programfiles%\7-zip\7z" a %filename% res\*.txt
"%programfiles%\7-zip\7z" a %filename% res\*.manifest
"%programfiles%\7-zip\7z" a -r %filename% res\components
"%programfiles%\7-zip\7z" a -r %filename% res\images
"%programfiles%\7-zip\7z" a -r %filename% res\Lang
"%programfiles%\7-zip\7z" a -r %filename% res\Templates\AppConsole
"%programfiles%\7-zip\7z" a -r %filename% "res\Templates\Dinamic Link Library"
"%programfiles%\7-zip\7z" a -r %filename% "res\Templates\Static Library"
"%programfiles%\7-zip\7z" a -r %filename% res\Templates\WindowsApp
"%programfiles%\7-zip\7z" a %filename% res\plugin\NSIS_EnvSet.txt
"%programfiles%\7-zip\7z" a -r %filename% res\plugin\NSIS_EnvSet
"%programfiles%\7-zip\7z" a -r %filename% res\Examples
"%programfiles%\7-zip\7z" a %filename% *.txt
