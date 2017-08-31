;NSIS Modern User Interface
;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"
  !include "FileFunc.nsh"
  !include "x64.nsh"
  !include "LogicLib.nsh"

  !define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
  !define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\orange.bmp"
  !define MUI_WELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\orange.bmp"
  !define MUI_FINISHPAGE_RUN
  !define MUI_FINISHPAGE_RUN_TEXT "Falcon C++"
  !define MUI_FINISHPAGE_RUN_FUNCTION "LaunchLink"

!addplugindir /x86-unicode "..\..\res\plugin\x86"
;!addplugindir /x64-unicode "..\..\res\plugin\x64"
;--------------------------------
; define
  !define PROJECT_NAME "Falcon C++"
  !define PROGRAM_NAME "Falcon"
  !define REG_UNINSTALL "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROGRAM_NAME}"
  !define SHCNE_ASSOCCHANGED 0x08000000
  !define SHCNF_IDLIST 0
  !define MAJ_VERSION "3.3"
  !define APP_VERSION "${MAJ_VERSION}.2.0"
  
; packages
  !define PKG_MAKE     "mingw32-make 3.82.90.fpk"
  !define PKG_RUNTIME  "mingw-runtime 3.20.fpk"
  !define PKG_BINUTILS "binutils 2.22.fpk"
  !define PKG_GDB      "gdb 7.6.fpk"
  !define PKG_WINAPI   "w32api 3.17.fpk"
  !define PKG_CODE     "gcc-core 4.7.1.fpk"
  !define PKG_CPP      "gcc-g++ 4.7.1.fpk"
;--------------------------------
;General

!ifdef Win64
  !define ARCH_NAME "Win64"
  !define ARCH "x64"
!else
  !define ARCH_NAME "Win32"
  !define ARCH "x86"
!endif
  ;Properly display all languages (Installer will not work on Windows 95, 98 or ME!)
  Unicode true

  Name "${PROJECT_NAME}"
;!define WITH_MINGW
!ifdef WITH_MINGW
  OutFile "..\..\bin\releases\Falcon C++-${APP_VERSION}-${ARCH_NAME}-Setup.exe"
!else  
  OutFile "..\..\bin\releases\Falcon C++-${APP_VERSION}-No-MinGW-${ARCH_NAME}-Setup.exe"
!endif

  ;Default installation folder
  InstallDir "$PROGRAMFILES\${PROGRAM_NAME}"

  ;Get installation folder from registry if available
  InstallDirRegKey HKLM "Software\${PROGRAM_NAME}" ""
  
  RequestExecutionLevel admin
  
;--------------------------------
;Version Information

  VIProductVersion "${APP_VERSION}"
  VIAddVersionKey /LANG=1046 "ProductName" "${PROJECT_NAME}"
  VIAddVersionKey /LANG=1046 "Comments" "C++ IDE easy and complete."
  VIAddVersionKey /LANG=1046 "CompanyName" "MZSW"
  VIAddVersionKey /LANG=1046 "LegalTrademarks" ""
  VIAddVersionKey /LANG=1046 "LegalCopyright" "Copyright"
  VIAddVersionKey /LANG=1046 "FileDescription" "C++ IDE easy and complete."
  VIAddVersionKey /LANG=1046 "FileVersion" "${APP_VERSION}"

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING

;--------------------------------
;Language Selection Dialog Settings

  ;Remember the installer language
  !define MUI_LANGDLL_REGISTRY_ROOT "HKLM" 
  !define MUI_LANGDLL_REGISTRY_KEY "Software\${PROGRAM_NAME}" 
  !define MUI_LANGDLL_REGISTRY_VALUENAME "Installer Language"

;--------------------------------
;Pages

  ;Pages Install
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE '..\..\res\license.txt'
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !define MUI_PAGE_CUSTOMFUNCTION_LEAVE PostInstPage
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH
  
  ;Pages Uninstall
  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_COMPONENTS
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH
  
;--------------------------------
;Languages Macro
  
  !macro LANG_LOAD LANGLOAD
    !insertmacro MUI_LANGUAGE "${LANGLOAD}"
    ;!verbose off
    !include "languages\${LANGLOAD}.nsh"
    ;!verbose on
    !undef LANG
  !macroend
 
  !macro LANG_STRING NAME VALUE
    LangString "${NAME}" "${LANG_${LANG}}" "${VALUE}"
  !macroend

  !macro LANG_UNSTRING NAME VALUE
    !insertmacro LANG_STRING "un.${NAME}" "${VALUE}"
  !macroend
  
;Shell Association
  
  !macro ADD_EXT_CMD EXT DESC EXEICON OPENWITH
    WriteRegStr HKCR ".${EXT}" "" "${EXT}.file"
    WriteRegStr HKCR "${EXT}.file" "" "${DESC}"  
    WriteRegStr HKCR "${EXT}.file\DefaultIcon" "" "$INSTDIR\${EXEICON}"
    WriteRegStr HKCR "${EXT}.file\shell\open\command" "" '"$INSTDIR\${OPENWITH}" "%1"'
  !macroend
  
  !macro ADD_EXT EXT DESC EXEICON 
    WriteRegStr HKCR ".${EXT}" "" "${EXT}.file"
    WriteRegStr HKCR "${EXT}.file" "" "${DESC}"  
    WriteRegStr HKCR "${EXT}.file\DefaultIcon" "" "$INSTDIR\${EXEICON}"
  !macroend
 
;Install Package

  !macro INST_PKG NAME DESC
    DetailPrint "${DESC}"
    SetDetailsPrint none  
    ExecWait '"$INSTDIR\PkgManager.exe" /S "$INSTDIR\${NAME}"'
    SetDetailsPrint both
  !macroend

;-------------------------------- 
;Separated language strings files

  !insertmacro LANG_LOAD "English"
;  !insertmacro LANG_LOAD "Portuguese"
  !insertmacro LANG_LOAD "PortugueseBR"
;  !insertmacro LANG_LOAD "Spanish"
  !insertmacro LANG_LOAD "Italian"
  !insertmacro LANG_LOAD "SimpChinese"
/*!insertmacro LANG_LOAD "French"
  !insertmacro LANG_LOAD "German"
  !insertmacro LANG_LOAD "SpanishInternational"
  !insertmacro LANG_LOAD "TradChinese"
  !insertmacro LANG_LOAD "Japanese"
  !insertmacro LANG_LOAD "Korean"
  !insertmacro LANG_LOAD "Dutch"
  !insertmacro LANG_LOAD "Danish"
  !insertmacro LANG_LOAD "Swedish"
  !insertmacro LANG_LOAD "Norwegian"
  !insertmacro LANG_LOAD "NorwegianNynorsk"
  !insertmacro LANG_LOAD "Finnish"
  !insertmacro LANG_LOAD "Greek"
  !insertmacro LANG_LOAD "Russian"
  !insertmacro LANG_LOAD "Polish"
  !insertmacro LANG_LOAD "Ukrainian"
  !insertmacro LANG_LOAD "Czech"
  !insertmacro LANG_LOAD "Slovak"
  !insertmacro LANG_LOAD "Croatian"
  !insertmacro LANG_LOAD "Bulgarian"
  !insertmacro LANG_LOAD "Hungarian"
  !insertmacro LANG_LOAD "Thai"
  !insertmacro LANG_LOAD "Romanian"
  !insertmacro LANG_LOAD "Latvian"
  !insertmacro LANG_LOAD "Macedonian"
  !insertmacro LANG_LOAD "Estonian"
  !insertmacro LANG_LOAD "Turkish"
  !insertmacro LANG_LOAD "Lithuanian"
  !insertmacro LANG_LOAD "Slovenian"
  !insertmacro LANG_LOAD "Serbian"
  !insertmacro LANG_LOAD "SerbianLatin"
  !insertmacro LANG_LOAD "Arabic"
  !insertmacro LANG_LOAD "Farsi"
  !insertmacro LANG_LOAD "Hebrew"
  !insertmacro LANG_LOAD "Indonesian"
  !insertmacro LANG_LOAD "Mongolian"
  !insertmacro LANG_LOAD "Luxembourgish"
  !insertmacro LANG_LOAD "Albanian"
  !insertmacro LANG_LOAD "Breton"
  !insertmacro LANG_LOAD "Belarusian"
  !insertmacro LANG_LOAD "Icelandic"
  !insertmacro LANG_LOAD "Malay"
  !insertmacro LANG_LOAD "Bosnian"
  !insertmacro LANG_LOAD "Kurdish"
  !insertmacro LANG_LOAD "Irish"
  !insertmacro LANG_LOAD "Uzbek"
  !insertmacro LANG_LOAD "Galician"
  !insertmacro LANG_LOAD "Afrikaans"
  !insertmacro LANG_LOAD "Catalan"
  !insertmacro LANG_LOAD "Esperanto"*/
  
  !insertmacro MUI_RESERVEFILE_LANGDLL
    
;--------------------------------
;custom functions

Function RefreshShellIcons
  System::Call 'shell32.dll::SHChangeNotify(i, i, i, i) v \
  (${SHCNE_ASSOCCHANGED}, ${SHCNF_IDLIST}, 0, 0)'
FunctionEnd

Function Un.RefreshShellIcons
  System::Call 'shell32.dll::SHChangeNotify(i, i, i, i) v \
  (${SHCNE_ASSOCCHANGED}, ${SHCNF_IDLIST}, 0, 0)'
FunctionEnd

;--------------------------------
;Installer Sections

SectionGroup "${PROJECT_NAME}" GroupFalcon

  Section "$(NAME_SecCore)" SecCore

    SectionIn RO
  
    SetOutPath "$INSTDIR"
  
    ;temporary to update
    StrCmp "$INSTDIR\Falcon.exe" $EXEPATH 0 diffexe
      CopyFiles $EXEPATH "$INSTDIR\${PROJECT_NAME}-${APP_VERSION}-No-MinGW-Setup.exe"
      ExecShell open "$INSTDIR\${PROJECT_NAME}-${APP_VERSION}-No-MinGW-Setup.exe"
      Abort
    diffexe:
    ;goto here if not equal

    File "..\..\bin\${ARCH}\Falcon.exe"
    File "..\..\bin\${ARCH}\SciLexer.dll"
    File "..\..\bin\${ARCH}\Updater.exe"
    File "..\..\bin\${ARCH}\AStyle.dll"
    File "..\..\bin\${ARCH}\ConsoleRunner.exe"
    File "..\..\bin\${ARCH}\PkgManager.exe"
    
    ;Create uninstaller
    WriteUninstaller "$INSTDIR\Uninstall.exe"
  
    ;Create Directories
    CreateDirectory "$INSTDIR\Help"
    CreateDirectory "$INSTDIR\Templates"
    CreateDirectory "$INSTDIR\Lang"
    CreateDirectory "$INSTDIR\Packages"
    
    ;Create ShortCuts
    SetShellVarContext all
    CreateDirectory "$SMPROGRAMS\${PROJECT_NAME}"
    createShortCut  "$SMPROGRAMS\${PROJECT_NAME}\${PROJECT_NAME}.lnk" "$INSTDIR\Falcon.exe" "" "" "" "" "" "C++ IDE easy and complete"
    createShortCut  "$SMPROGRAMS\${PROJECT_NAME}\PkgManager.lnk" "$INSTDIR\PkgManager.exe" "" "" "" "" "" "$(DESC_LinkPkgMan)"
    createShortCut  "$SMPROGRAMS\${PROJECT_NAME}\Updater.lnk" "$INSTDIR\Updater.exe" "" "" "" "" "" "$(DESC_LinkUpdater)"
    createShortCut  "$SMPROGRAMS\${PROJECT_NAME}\Uninstall.lnk" "$INSTDIR\Uninstall.exe" "" "" "" "" "" "$(DESC_LinkUninstall)"
    
    ;Writing uninstall info to registry:
    WriteRegStr HKLM "${REG_UNINSTALL}" "DisplayName" "${PROJECT_NAME} ${MAJ_VERSION}"
    WriteRegStr HKLM "${REG_UNINSTALL}" "DisplayIcon" "$INSTDIR\Falcon.exe"
    WriteRegStr HKLM "${REG_UNINSTALL}" "DisplayVersion" "${APP_VERSION}"
    WriteRegStr HKLM "${REG_UNINSTALL}" "Publisher" "Mazin sw"
    WriteRegStr HKLM "${REG_UNINSTALL}" "URLInfoAbout" "http://sourceforge.net/users/francimar"
    WriteRegStr HKLM "${REG_UNINSTALL}" "URLUpdateInfo" "https://sourceforge.net/projects/falconcpp/"
   
    WriteRegDWord HKLM "${REG_UNINSTALL}" "NoModify" 1
    WriteRegDWord HKLM "${REG_UNINSTALL}" "NoRepair" 1
    WriteRegStr   HKLM "${REG_UNINSTALL}" "UninstallString" "$INSTDIR\Uninstall.exe"
    
    ; save install dir
    WriteRegStr HKLM "Software\${PROGRAM_NAME}" "" $INSTDIR
    WriteRegStr HKLM "Software\${PROGRAM_NAME}" "Version" "${APP_VERSION}"

    ;write language id
    SetShellVarContext current
    CreateDirectory "$APPDATA\${PROGRAM_NAME}"
    WriteINIStr "$APPDATA\${PROGRAM_NAME}\Config.ini" "EnvironmentOptions" "LanguageID" $LANGUAGE
    
    ;Custom Code Template
    SetOutPath "$APPDATA\${PROGRAM_NAME}"
    IfFileExists "$APPDATA\${PROGRAM_NAME}\CustomAutoComplete.txt" file_found 0
      File "..\..\res\CustomAutoComplete.txt"
    file_found:
    SetOutPath "$INSTDIR"
   
   ;reaload all source files to cache
    WriteINIStr "$APPDATA\${PROGRAM_NAME}\Config.ini" "Packages" "NewInstalled" -1
 
    ; fpj Falcon C++ Project File
    !insertmacro ADD_EXT_CMD "fpj" "$(DESC_Assoc_FPJ)" "Falcon.exe" "Falcon.exe"

    ; ftm Falcon C++ Template file
    !insertmacro ADD_EXT_CMD "ftm" "$(DESC_Assoc_FTM)" "Falcon.exe,1" "PkgManager.exe"
  
    ; fpk Falcon C++ Package file
    !insertmacro ADD_EXT_CMD "fpk" "$(DESC_Assoc_FPK)" "Falcon.exe,2" "PkgManager.exe"
  
  Call RefreshShellIcons
  
  SectionEnd
  
  Section "$(NAME_SecFtm)" SecFtm
    SetOutPath "$INSTDIR\Templates"
    File "..\..\res\Templates\AppConsole.ftm"
    File "..\..\res\Templates\Dinamic Link Library.ftm"
    File "..\..\res\Templates\WindowsApp.ftm"  
    File "..\..\res\Templates\Static Library.ftm" 
  SectionEnd
  Section "$(NAME_SecAssoc)" SecAssoc 
    SetOutPath "$INSTDIR"
    ; c file
    !insertmacro ADD_EXT_CMD "c" "$(DESC_Assoc_C)" "Falcon.exe,3" "Falcon.exe"
    !insertmacro ADD_EXT_CMD "cc" "$(DESC_Assoc_C)" "Falcon.exe,3" "Falcon.exe"
    
    ; cpp file
    !insertmacro ADD_EXT_CMD "cpp" "$(DESC_Assoc_CPP)" "Falcon.exe,4" "Falcon.exe"
    !insertmacro ADD_EXT_CMD "cxx" "$(DESC_Assoc_CPP)" "Falcon.exe,4" "Falcon.exe"
    !insertmacro ADD_EXT_CMD "c++" "$(DESC_Assoc_CPP)" "Falcon.exe,4" "Falcon.exe"
    !insertmacro ADD_EXT_CMD "cp" "$(DESC_Assoc_CPP)" "Falcon.exe,4" "Falcon.exe"

    ; h file
    !insertmacro ADD_EXT_CMD "h" "$(DESC_Assoc_H)" "Falcon.exe,5" "Falcon.exe"
    !insertmacro ADD_EXT_CMD "hpp" "$(DESC_Assoc_H)" "Falcon.exe,5" "Falcon.exe"
    !insertmacro ADD_EXT_CMD "hh" "$(DESC_Assoc_H)" "Falcon.exe,5" "Falcon.exe"
    !insertmacro ADD_EXT_CMD "rh" "$(DESC_Assoc_H)" "Falcon.exe,5" "Falcon.exe"
    
    ; rc file
    !insertmacro ADD_EXT_CMD "rc" "$(DESC_Assoc_RC)" "Falcon.exe,6" "Falcon.exe"

    ; inl file
    !insertmacro ADD_EXT_CMD "inl" "$(DESC_Assoc_INL)" "Falcon.exe,7" "Falcon.exe"

    ; res file
    !insertmacro ADD_EXT "res" "$(DESC_Assoc_RES)" "Falcon.exe,8"

    ; object file
    !insertmacro ADD_EXT "o" "$(DESC_Assoc_O)" "Falcon.exe,9"

    ; lib file
    !insertmacro ADD_EXT "a" "$(DESC_Assoc_A)" "Falcon.exe,10"
  
    Call RefreshShellIcons
    
  SectionEnd
  
  Section "$(NAME_SecLangFile)" SecLangFile 
    SetOutPath "$INSTDIR\Lang" 
    File "..\..\res\Lang\Portuguese.lng"
    File "..\..\res\Lang\Italian.lng"
    File "..\..\res\Lang\Simplified Chinese.lng"
  SectionEnd
  Section "$(NAME_SecDeskScut)" SecDeskScut 
    SetOutPath "$INSTDIR"
  SetShellVarContext all
    createShortCut "$DESKTOP\${PROJECT_NAME}.lnk" "$INSTDIR\Falcon.exe" "" "" "" "" "" "C++ IDE easy and complete" 
  SectionEnd
  Section "$(NAME_SecQckLScut)" SecQckLScut 
    SetOutPath "$INSTDIR"
  SetShellVarContext all
    createShortCut "$QUICKLAUNCH\${PROJECT_NAME}.lnk" "$INSTDIR\Falcon.exe" "" "" "" "" "" "C++ IDE easy and complete"  
  SectionEnd
SectionGroupEnd

!ifdef WITH_MINGW
Section "$(NAME_SecMinGW)" SecMinGW

  SetOutPath "$INSTDIR"
  
  ;MinGW Packages
  File "..\..\res\Packages\${PKG_MAKE}"
  File "..\..\res\Packages\${PKG_RUNTIME}"
  File "..\..\res\Packages\${PKG_BINUTILS}"
  File "..\..\res\Packages\${PKG_GDB}"
  File "..\..\res\Packages\${PKG_WINAPI}"
  File "..\..\res\Packages\${PKG_CODE}"
  File "..\..\res\Packages\${PKG_CPP}"
  
  ;Install MinGW Packages
  DetailPrint "$(DESC_InstMinGW)"
  !insertmacro INST_PKG "${PKG_RUNTIME}" "$(DESC_InstRuntime)"
  !insertmacro INST_PKG "${PKG_CODE}" "$(DESC_InstGCC_Core)"
  !insertmacro INST_PKG "${PKG_CPP}" "$(DESC_InstGCC_GPP)"
  !insertmacro INST_PKG "${PKG_GDB}" "$(DESC_InstGDB)"
  !insertmacro INST_PKG "${PKG_BINUTILS}" "$(DESC_InstBinutils)"
  !insertmacro INST_PKG "${PKG_MAKE}" "$(DESC_InstMake)"
  !insertmacro INST_PKG "${PKG_WINAPI}" "$(DESC_InstW32API)"
  
  ;Delete installeds packages
  Delete "$INSTDIR\${PKG_MAKE}"
  Delete "$INSTDIR\${PKG_RUNTIME}"
  Delete "$INSTDIR\${PKG_BINUTILS}"
  Delete "$INSTDIR\${PKG_GDB}"
  Delete "$INSTDIR\${PKG_WINAPI}"
  Delete "$INSTDIR\${PKG_CODE}"
  Delete "$INSTDIR\${PKG_CPP}"
  
  ;write compiler path
  SetShellVarContext current
  WriteINIStr "$APPDATA\${PROGRAM_NAME}\Config.ini" "CompilerOptions" "Path" "$INSTDIR\MinGW"
  
  DetailPrint "$(DESC_AdjEnvVar)"
  NSIS_EnvSet::AddVariableToPath "$INSTDIR\MinGW\bin"

SectionEnd
!endif

;--------------------------------
;Uninstaller Section

Section "Un.Falcon C++" UnSecCore

  SectionIn RO
  
  SetShellVarContext all
  ;delete shortcuts
  Delete "$SMPROGRAMS\${PROJECT_NAME}\${PROJECT_NAME}.lnk"
  Delete "$SMPROGRAMS\${PROJECT_NAME}\PkgManager.lnk"
  Delete "$SMPROGRAMS\${PROJECT_NAME}\Updater.lnk"
  Delete "$SMPROGRAMS\${PROJECT_NAME}\Uninstall.lnk"
  RMDir  "$SMPROGRAMS\${PROJECT_NAME}"
  
  Delete "$DESKTOP\${PROJECT_NAME}.lnk"
  Delete "$QUICKLAUNCH\${PROJECT_NAME}.lnk"
  
  ;delete languages files
  Delete "$INSTDIR\Lang\Portuguese.lng"
  Delete "$INSTDIR\Lang\Simplified Chinese.lng"
  Delete "$INSTDIR\Lang\Italian.lng"
  RMDir  "$INSTDIR\Lang"
  
  ;delete help
  ;Delete "$INSTDIR\Help\falcon.chm"
  RMDir  "$INSTDIR\Help"
  
  ;delete templates
  Delete "$INSTDIR\Templates\AppConsole.ftm"
  Delete "$INSTDIR\Templates\Dinamic Link Library.ftm"
  Delete "$INSTDIR\Templates\WindowsApp.ftm"  
  Delete "$INSTDIR\Templates\Static Library.ftm" 
  RMDir  "$INSTDIR\Templates"

  ;delete Falcon C++ Files
  Delete "$INSTDIR\Falcon.exe"
  Delete "$INSTDIR\SciLexer.dll"
  Delete "$INSTDIR\PkgManager.exe"
  Delete "$INSTDIR\Updater.exe"
  ;delete tools
  Delete "$INSTDIR\AStyle.dll"
  Delete "$INSTDIR\ConsoleRunner.exe"
  Delete "$INSTDIR\Uninstall.exe"
  RMDir  "$INSTDIR"
  
  ;remove extension association
  DeleteRegKey HKLM "${REG_UNINSTALL}"
  DeleteRegKey HKCR ".fpj"
  DeleteRegKey HKCR "fpj.file"
  DeleteRegKey HKCR ".ftm"
  DeleteRegKey HKCR "ftm.file"
  DeleteRegKey HKCR ".fpk"
  DeleteRegKey HKCR "fpk.file"
  DeleteRegKey HKLM "Software\${PROGRAM_NAME}"
  Call Un.RefreshShellIcons
  
SectionEnd

Section "Un.$(NAME_SecMinGW)" UnSecMinGW
  
  ;don't uninstall MinGW if run in silent mode
  IfSilent +4 0
  NSIS_EnvSet::DeleteEnvironmentVariable "MINGW_PATH"
  NSIS_EnvSet::DelVariableOfPath "%MINGW_PATH%\bin"
  RMDir /r "$INSTDIR"
  ;+4 jump here 

SectionEnd

;-------------------------------
;Installer functions
Function .onInit

  !insertmacro MUI_LANGDLL_DISPLAY
  ReadRegStr $2 HKLM "Software\${PROGRAM_NAME}" ""
  ${If} $2 == ""
    ReadRegStr $2 HKLM "${REG_UNINSTALL}" "UninstallString"
    ${If} $2 != ""
      ${GetParent} $2 $0
      StrCpy $INSTDIR $0
    ${EndIf}
  ${EndIf}

!ifdef Win64
  StrCpy $InstDir "$PROGRAMFILES64\${PROGRAM_NAME}"
!else
  StrCpy $InstDir "$PROGRAMFILES32\${PROGRAM_NAME}"
!endif

FunctionEnd

Function un.onInit

  !insertmacro MUI_UNGETLANGUAGE
  
FunctionEnd

Function PostInstPage
 
  ; Don't advance automatically if details expanded
  FindWindow $R0 "#32770" "" $HWNDPARENT
  GetDlgItem $R0 $R0 1016
  System::Call user32::IsWindowVisible(i$R0)i.s
  Pop $R0
 
  StrCmp $R0 0 +2
  SetAutoClose false
 
FunctionEnd

;--------------------------------
;Descriptions

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecCore} $(DESC_SecCore)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecFtm} $(DESC_SecFtm)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecAssoc} $(DESC_SecAssoc)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecLangFile} $(DESC_SecLangFile)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecDeskScut} $(DESC_SecDeskScut)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecQckLScut} $(DESC_SecQckLScut)
!ifdef WITH_MINGW
  !insertmacro MUI_DESCRIPTION_TEXT ${SecMinGW} $(DESC_SecMinGW)
!endif  
  !insertmacro MUI_FUNCTION_DESCRIPTION_END
  
  !insertmacro MUI_UNFUNCTION_DESCRIPTION_BEGIN 
    !insertmacro MUI_DESCRIPTION_TEXT ${UnSecCore} $(DESC_SecCore)
    !insertmacro MUI_DESCRIPTION_TEXT ${UnSecMinGW} $(DESC_SecMinGW)  
  !insertmacro MUI_UNFUNCTION_DESCRIPTION_END
;--------------------------------
;Launch after instalation function

Function LaunchLink
  SetOutPath "$INSTDIR"
  ExecShell "open" "$INSTDIR\Falcon.exe"
FunctionEnd

