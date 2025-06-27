!define APP_NAME "Image Format Converter"
!define INSTALL_DIR "$PROGRAMFILES64\ImageConverter"
!define UNINSTALL_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\ImageConverter"

Outfile "ImageConverterSetup.exe"
InstallDir "${INSTALL_DIR}"
RequestExecutionLevel admin
ShowInstDetails show
ShowUninstDetails show

Section "Install"

  SetOutPath "$INSTDIR"
  File "converter.exe"
  File "icon_png.ico"
  File "icon_jpg.ico"
  File "icon_webp.ico"

  ; Register context menu for each image extension
  ; PNG
  WriteRegStr HKCR "SystemFileAssociations\.png\shell\ImageConvert" "" "Convert Image..."
  WriteRegStr HKCR "SystemFileAssociations\.png\shell\ImageConvert" "SubCommands" "ImageConvert.png;ImageConvert.jpg;ImageConvert.webp"

  ; JPG
  WriteRegStr HKCR "SystemFileAssociations\.jpg\shell\ImageConvert" "" "Convert Image..."
  WriteRegStr HKCR "SystemFileAssociations\.jpg\shell\ImageConvert" "SubCommands" "ImageConvert.png;ImageConvert.jpg;ImageConvert.webp"

  ; WEBP
  WriteRegStr HKCR "SystemFileAssociations\.webp\shell\ImageConvert" "" "Convert Image..."
  WriteRegStr HKCR "SystemFileAssociations\.webp\shell\ImageConvert" "SubCommands" "ImageConvert.png;ImageConvert.jpg;ImageConvert.webp"

  ; Add CommandStore entries for submenu options
  ; Convert to PNG
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ImageConvert.png" "" "Convert to PNG"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ImageConvert.png" "Icon" "$INSTDIR\icon_png.ico"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ImageConvert.png\command" "" '"$INSTDIR\converter.exe" --to=png "%1"'

  ; Convert to JPG
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ImageConvert.jpg" "" "Convert to JPG"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ImageConvert.jpg" "Icon" "$INSTDIR\icon_jpg.ico"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ImageConvert.jpg\command" "" '"$INSTDIR\converter.exe" --to=jpg "%1"'

  ; Convert to WEBP
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ImageConvert.webp" "" "Convert to WEBP"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ImageConvert.webp" "Icon" "$INSTDIR\icon_webp.ico"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ImageConvert.webp\command" "" '"$INSTDIR\converter.exe" --to=webp "%1"'

  ; Add to uninstall list
  WriteRegStr HKLM "${UNINSTALL_KEY}" "DisplayName" "${APP_NAME}"
  WriteRegStr HKLM "${UNINSTALL_KEY}" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteUninstaller "$INSTDIR\uninstall.exe"

SectionEnd

Section "Uninstall"

  Delete "$INSTDIR\converter.exe"
  Delete "$INSTDIR\icon_png.ico"
  Delete "$INSTDIR\icon_jpg.ico"
  Delete "$INSTDIR\icon_webp.ico"

  RMDir "$INSTDIR"

  ; Remove CommandStore entries
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ImageConvert.png"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ImageConvert.jpg"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ImageConvert.webp"

  ; Remove context menu from each image type
  DeleteRegKey HKCR "SystemFileAssociations\.png\shell\ImageConvert"
  DeleteRegKey HKCR "SystemFileAssociations\.jpg\shell\ImageConvert"
  DeleteRegKey HKCR "SystemFileAssociations\.webp\shell\ImageConvert"

  ; Remove from uninstall list
  DeleteRegKey HKLM "${UNINSTALL_KEY}"

SectionEnd
