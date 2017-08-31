@ECHO OFF
call copy_files
call reduce_size
SET version="3.3.2.0"
SET filename="%~d0%~p0Falcon C++-%version%-Portable.zip"
SET filename_no_mingw="%~d0%~p0Falcon C++-%version%-Portable-No-MinGW.zip"
rm -f %filename_no_mingw%
rm -f %filename%
"%programfiles%\7-zip\7z" -tzip a -r %filename_no_mingw% x86 -x!MinGW -x!Config -x!Packages
"%programfiles%\7-zip\7z" -tzip a -r %filename% x86 -x!Config
