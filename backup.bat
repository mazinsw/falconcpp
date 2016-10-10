@echo OFF 
set sevenzip="%programfiles%\7-zip\7z.exe"
if not exist %sevenzip% (
	set sevenzip="%programfiles(x86)%\7-zip\7z.exe"
)
if not exist %sevenzip% goto no_7z

For /f "tokens=1-6 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%b-%%a)
For /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a-%%b)
for %%A in ("%~dp0\..\.") do (set currdir=%%~nxA)
SET filename="%~dp0backup\%currdir% %mydate%_%mytime%.7z"
echo %filename%
cd res
call clean
cd ..
cd src
call clean
cd ..
%sevenzip% a %filename% docs\help
%sevenzip% a %filename% src
%sevenzip% a %filename% tests
%sevenzip% a %filename% bin\make_installer.bat
%sevenzip% a %filename% bin\reduce_size.bat
%sevenzip% a %filename% res\*.txt
%sevenzip% a %filename% res\*.manifest
%sevenzip% a %filename% res\components
%sevenzip% a %filename% res\images
%sevenzip% a %filename% res\Lang
%sevenzip% a %filename% res\Templates\AppConsole
%sevenzip% a %filename% "res\Templates\Dinamic Link Library"
%sevenzip% a %filename% "res\Templates\Static Library"
%sevenzip% a %filename% res\Templates\WindowsApp
%sevenzip% a %filename% res\Examples
%sevenzip% a %filename% *.txt

goto end

:no_7z
echo The 7-Zip File Manager is not installed
pause
goto end

:end