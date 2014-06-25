@ECHO OFF
call reduce_size
SET version="3.3.2.0"
SET filename="%~d0%~p0Falcon C++-%version%-Portable.zip"
SET filename_no_mingw="%~d0%~p0Falcon C++-%version%-Portable-No-MinGW.zip"
rm -f %filename_no_mingw%
rm -f %filename%
copy /Y Falcon.exe Falcon\
copy /Y PkgManager.exe Falcon\
copy /Y Updater.exe Falcon\
copy /Y ConsoleRunner.exe Falcon\
copy /Y SciLexer.dll Falcon\
copy /Y AStyle.dll Falcon\
copy /Y AStyle.dll Falcon\
copy /Y ..\res\Templates\*.ftm Falcon\Templates\
copy /Y ..\res\Lang\*.lng Falcon\Lang\
"%programfiles%\7-zip\7z" -tzip a -r %filename_no_mingw% Falcon -x!MinGW -x!Config
"%programfiles%\7-zip\7z" -tzip a -r %filename% Falcon -x!Config
