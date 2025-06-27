!include "MUI2.nsh"

!define APP_NAME "Image Format Converter"
!define INSTALL_DIR "$PROGRAMFILES64\ImageConverter"
!define UNINSTALL_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\ImageConverter"

Unicode true
RequestExecutionLevel admin
Outfile "ImageConverterSetup.exe"
InstallDir "${INSTALL_DIR}"

!include "x64.nsh"

Name "Image Converter Installer"

Var /GLOBAL PRODUCT_NAME
Var /GLOBAL PRODUCT_VERSION
Var /GLOBAL PRODUCT_PUBLISHER

Function setVars
    StrCpy $PRODUCT_NAME "Image Format Converter"
    StrCpy $PRODUCT_VERSION "1.0.0"
    StrCpy $PRODUCT_PUBLISHER "Glowstudent"
FunctionEnd

Function .onInit
    ${If} ${RunningX64}
        SetRegView 64
    ${EndIf}
    Call setVars
FunctionEnd

BrandingText "$PRODUCT_NAME $PRODUCT_VERSION by $PRODUCT_PUBLISHER"

ShowInstDetails show
ShowUninstDetails show

!insertmacro MUI_PAGE_LICENSE "LICENSE"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"

Section "Install"

  ; ===== Copy Files =====
  SetOutPath "$INSTDIR"
  File /r "build\Release\*"
  File "assets\icons\icon_png.ico"
  File "assets\icons\icon_jpg.ico"
  File "assets\icons\icon_webp.ico"

  ; ===== PNG Context Menu =====
  WriteRegStr HKLM "Software\Classes\SystemFileAssociations\.png\shell\ImageConvert" "MUIVerb" "Convert Image..."
  WriteRegStr HKLM "Software\Classes\SystemFileAssociations\.png\shell\ImageConvert" "SubCommands" "ImageConvert_png;ImageConvert_jpg;ImageConvert_webp"
  WriteRegStr HKLM "Software\Classes\SystemFileAssociations\.png\shell\ImageConvert" "Icon" "$INSTDIR\icon_png.ico"

  ; ===== JPG Context Menu =====
  WriteRegStr HKLM "Software\Classes\SystemFileAssociations\.jpg\shell\ImageConvert" "MUIVerb" "Convert Image..."
  WriteRegStr HKLM "Software\Classes\SystemFileAssociations\.jpg\shell\ImageConvert" "SubCommands" "ImageConvert_png;ImageConvert_jpg;ImageConvert_webp"
  WriteRegStr HKLM "Software\Classes\SystemFileAssociations\.jpg\shell\ImageConvert" "Icon" "$INSTDIR\icon_jpg.ico"

  ; ===== JPEG Context Menu =====
  WriteRegStr HKLM "Software\Classes\SystemFileAssociations\.jpeg\shell\ImageConvert" "MUIVerb" "Convert Image..."
  WriteRegStr HKLM "Software\Classes\SystemFileAssociations\.jpeg\shell\ImageConvert" "SubCommands" "ImageConvert_png;ImageConvert_jpg;ImageConvert_webp"
  WriteRegStr HKLM "Software\Classes\SystemFileAssociations\.jpeg\shell\ImageConvert" "Icon" "$INSTDIR\icon_jpg.ico"

  ; ===== WEBP Context Menu =====
  WriteRegStr HKLM "Software\Classes\SystemFileAssociations\.webp\shell\ImageConvert" "MUIVerb" "Convert Image..."
  WriteRegStr HKLM "Software\Classes\SystemFileAssociations\.webp\shell\ImageConvert" "SubCommands" "ImageConvert_png;ImageConvert_jpg;ImageConvert_webp"
  WriteRegStr HKLM "Software\Classes\SystemFileAssociations\.webp\shell\ImageConvert" "Icon" "$INSTDIR\icon_webp.ico"

  ; ===== CommandStore: Convert to PNG =====
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ImageConvert_png" "" "Convert to PNG"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ImageConvert_png\command" "" '"$INSTDIR\converter.exe" --to=png "%1"'

  ; ===== CommandStore: Convert to JPG =====
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ImageConvert_jpg" "" "Convert to JPG"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ImageConvert_jpg\command" "" '"$INSTDIR\converter.exe" --to=jpg "%1"'

  ; ===== CommandStore: Convert to WEBP =====
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ImageConvert_webp" "" "Convert to WEBP"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ImageConvert_webp\command" "" '"$INSTDIR\converter.exe" --to=webp "%1"'

  ; ===== Uninstall Information =====
  WriteRegStr HKLM "${UNINSTALL_KEY}" "DisplayName" "${APP_NAME}"
  WriteRegStr HKLM "${UNINSTALL_KEY}" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteUninstaller "$INSTDIR\uninstall.exe"

SectionEnd

Section "Uninstall"

  ; ===== Remove Installed Files =====
  Delete "$INSTDIR\converter.exe"
  Delete "$INSTDIR\icon_png.ico"
  Delete "$INSTDIR\icon_jpg.ico"
  Delete "$INSTDIR\icon_webp.ico"
  Delete "$INSTDIR\uninstall.exe"
  RMDir "$INSTDIR"

  ; ===== Remove CommandStore Entries =====
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ImageConvert_png"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ImageConvert_jpg"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ImageConvert_webp"

  ; ===== Remove Context Menu Entries =====
  DeleteRegKey HKCR "SystemFileAssociations\.png\shell\ImageConvert"
  DeleteRegKey HKCR "SystemFileAssociations\.jpg\shell\ImageConvert"
  DeleteRegKey HKCR "SystemFileAssociations\.jpeg\shell\ImageConvert"
  DeleteRegKey HKCR "SystemFileAssociations\.webp\shell\ImageConvert"

  ; ===== Remove Uninstall Entry =====
  DeleteRegKey HKLM "${UNINSTALL_KEY}"

SectionEnd