@ECHO OFF
echo Copiyng files
copy /Y "..\res\Lang\*.lng" ".\x86\Lang\"
copy /Y "..\res\Lang\*.lng" ".\x64\Lang\"

copy /Y "..\res\Templates\*.ftm" ".\x86\Templates\"
copy /Y "..\res\Templates\*.ftm" ".\x64\Templates\"