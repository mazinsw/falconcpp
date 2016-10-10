@echo OFF 
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
For /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a-%%b)
SET version="3.3.2.0"
SET filename="%~d0%~p0Falcon C++-%version%-Source.tar"
SET gzfilename="%~d0%~p0Falcon C++-%version%-Source.tar.gz"
del %filename%

cd res
call clean
cd ..
cd src
call clean
cd ..
"%programfiles%\7-zip\7z" -ttar a %filename% docs\help -xr!.svn
"%programfiles%\7-zip\7z" -ttar a %filename% src -xr!.svn
"%programfiles%\7-zip\7z" -ttar a %filename% tests -xr!.svn -xr!*.exe
"%programfiles%\7-zip\7z" -ttar a %filename% bin\make_installer.bat -xr!.svn
"%programfiles%\7-zip\7z" -ttar a %filename% bin\reduce_size.bat -xr!.svn
"%programfiles%\7-zip\7z" -ttar a %filename% res\*.txt -xr!.svn
"%programfiles%\7-zip\7z" -ttar a %filename% res\*.manifest -xr!.svn
"%programfiles%\7-zip\7z" -ttar a %filename% res\components -xr!.svn
"%programfiles%\7-zip\7z" -ttar a %filename% res\images -xr!.svn
"%programfiles%\7-zip\7z" -ttar a %filename% res\Lang -xr!.svn
"%programfiles%\7-zip\7z" -ttar a %filename% res\Templates\AppConsole -xr!.svn
"%programfiles%\7-zip\7z" -ttar a %filename% "res\Templates\Dinamic Link Library" -xr!.svn
"%programfiles%\7-zip\7z" -ttar a %filename% "res\Templates\Static Library" -xr!.svn
"%programfiles%\7-zip\7z" -ttar a %filename% res\Templates\WindowsApp -xr!.svn
"%programfiles%\7-zip\7z" -ttar a %filename% res\Examples -xr!.svn
"%programfiles%\7-zip\7z" -ttar a %filename% *.txt
"%programfiles%\7-zip\7z" -tgzip a %gzfilename% %filename%
del %filename%
