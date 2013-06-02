@echo OFF 
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
For /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a-%%b)
SET version="3.3.0.0"
SET filename="%~d0%~p0Falcon C++-%version%-Source.tar"
SET gzfilename="%~d0%~p0Falcon C++-%version%-Source.tar.gz"
del %filename%

call src/clean
call res/clean
"%programfiles%\7-zip\7z" -ttar a -r %filename% docs\help -xr!.svn
"%programfiles%\7-zip\7z" -ttar a -r %filename% src -xr!.svn
"%programfiles%\7-zip\7z" -ttar a -r %filename% tests -xr!.svn -xr!*.exe
"%programfiles%\7-zip\7z" -ttar a -r %filename% bin\make_installer.bat -xr!.svn
"%programfiles%\7-zip\7z" -ttar a -r %filename% bin\reduce_size.bat -xr!.svn
"%programfiles%\7-zip\7z" -ttar a %filename% res\*.txt -xr!.svn
"%programfiles%\7-zip\7z" -ttar a %filename% res\*.manifest -xr!.svn
"%programfiles%\7-zip\7z" -ttar a -r %filename% res\components -xr!.svn
"%programfiles%\7-zip\7z" -ttar a -r %filename% res\images -xr!.svn
"%programfiles%\7-zip\7z" -ttar a -r %filename% res\Lang -xr!.svn
"%programfiles%\7-zip\7z" -ttar a -r %filename% res\Templates\AppConsole -xr!.svn
"%programfiles%\7-zip\7z" -ttar a -r %filename% "res\Templates\Dinamic Link Library" -xr!.svn
"%programfiles%\7-zip\7z" -ttar a -r %filename% "res\Templates\Static Library" -xr!.svn
"%programfiles%\7-zip\7z" -ttar a -r %filename% res\Templates\WindowsApp -xr!.svn
"%programfiles%\7-zip\7z" -ttar a %filename% res\plugin\NSIS_EnvSet.txt -xr!.svn
"%programfiles%\7-zip\7z" -ttar a -r %filename% res\plugin\NSIS_EnvSet -xr!.svn
"%programfiles%\7-zip\7z" -ttar a -r %filename% res\Examples -xr!.svn
"%programfiles%\7-zip\7z" -ttar a %filename% *.txt -xr!.svn
"%programfiles%\7-zip\7z" -tgzip a %gzfilename% %filename%
del %filename%
