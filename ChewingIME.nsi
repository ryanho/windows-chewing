; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "新酷音輸入法"
!define PRODUCT_VERSION "0.3.1"
!define PRODUCT_PUBLISHER "PCMan (洪任諭), seamxr, andyhorng"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

SetCompressor lzma

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"

Function uninstOld
  ClearErrors
  IfFileExists "$SYSDIR\Chewing.ime" 0 ContinueUninst
    Delete "$SYSDIR\Chewing.ime"
    IfErrors 0 ContinueUninst
      MessageBox MB_ICONSTOP|MB_OK "解安裝舊版發生錯誤，請確定你有系統管理員權限，以及舊版不在使用中$\n$\n建議到控制台輸入法設定當中，移除舊版後登出或重開機後再安裝。"
      Abort
  ContinueUninst:

  FindWindow $0 "ChewingServer"
  SendMessage $0 ${WM_DESTROY} 0 0

  ExecWait '"$SYSDIR\IME\Chewing\Installer.exe" /uninstall'

  Delete "$SYSDIR\IME\Chewing\License.txt"
  Delete "$SYSDIR\IME\Chewing\statuswnd.bmp"
  Delete "$SYSDIR\IME\Chewing\ch_index.dat"
  Delete "$SYSDIR\IME\Chewing\dict.dat"
  Delete "$SYSDIR\IME\Chewing\fonetree.dat"
  Delete "$SYSDIR\IME\Chewing\ph_index.dat"
  Delete "$SYSDIR\IME\Chewing\us_freq.dat"
  Delete "$SYSDIR\IME\Chewing\Chewing.chm"
  Delete "$SYSDIR\IME\Chewing\Installer.exe"
  Delete "$SYSDIR\IME\Chewing\ChewingServer.exe"
  Delete "$SYSDIR\IME\Chewing\HashEd.exe"
  Delete "$SYSDIR\IME\Chewing\Update.exe"

  Delete "$SMPROGRAMS\新酷音輸入法\新酷音輸入法使用說明.lnk"
  Delete "$SMPROGRAMS\新酷音輸入法\本地詞庫編輯工具.lnk"
  Delete "$SMPROGRAMS\新酷音輸入法\解除安裝.lnk"

  RMDir "$SYSDIR\IME\Chewing"
  RMDir "$SMPROGRAMS\新酷音輸入法"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"

  Delete "$INSTDIR\uninst.exe"
FunctionEnd

Function .onInit
  ReadRegStr $0 ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion"
  StrCmp $0 "" ContinueInst 0 
    MessageBox MB_OKCANCEL|MB_ICONQUESTION "偵測到舊版 ${PRODUCT_NAME}已安裝，是否要自動移除舊版後重裝新版？" IDOK +2
      Abort
      Call uninstOld
  ContinueInst:
FunctionEnd

BGGradient 0000FF 000000 FFFFFF

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!define MUI_LICENSEPAGE_RADIOBUTTONS
!insertmacro MUI_PAGE_LICENSE "License.txt"
; Directory page
; !insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_LINK_LOCATION "http://chewing.csie.net/"
!define MUI_FINISHPAGE_LINK "參觀新酷音輸入法網站： ${MUI_FINISHPAGE_LINK_LOCATION}"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "TradChinese"

; Reserve files
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "win32-chewing-${PRODUCT_VERSION}.exe"
InstallDir "$SYSDIR\IME\Chewing"
ShowInstDetails show
ShowUnInstDetails show

Function OnInstError
    MessageBox MB_ICONSTOP|MB_OK "安裝發生錯誤，請確定你有系統管理員權限，以及舊版不在執行中$\n$\n建議到控制台輸入法設定當中，移除舊版後登出或重開機後再安裝。"
    Abort
FunctionEnd

Section "MainSection" SEC01
  SetOutPath "$SYSDIR\IME\Chewing"
  SetOverwrite on
  File "..\libchewing-data\utf-8\us_freq.dat"
  File /oname=ph_index.dat "..\libchewing-data\utf-8\ph_index.dat"
  File /oname=fonetree.dat "..\libchewing-data\utf-8\fonetree.dat"
  File "..\libchewing-data\utf-8\dict.dat"
  File /oname=ch_index.dat "..\libchewing-data\utf-8\ch_index.dat"
  File "Data\statuswnd.bmp"
  File "License.txt"
  File "UserGuide\chewing.chm"
  File "Installer\Release\Installer.exe"
  File "ChewingServer\Release\ChewingServer.exe"
  File "HashEd-UTF8\Release\HashEd.exe"
  File "OnlineUpdate\Release\Update.exe"
  File /oname=$TEMP\big52utf8.exe "big52utf8\Release\big52utf8.exe"
  SetOutPath "$SYSDIR"
  File "ChewingIME\Release\Chewing.ime"

  IfErrors 0 +2
    Call OnInstError
SectionEnd

Section -AdditionalIcons
  SetOutPath $INSTDIR
  CreateDirectory "$SMPROGRAMS\新酷音輸入法"
  CreateShortCut "$SMPROGRAMS\新酷音輸入法\新酷音輸入法使用說明.lnk" "$INSTDIR\Chewing.chm"
  CreateShortCut "$SMPROGRAMS\新酷音輸入法\本地詞庫編輯工具.lnk" "$INSTDIR\HashEd.exe"
  CreateShortCut "$SMPROGRAMS\新酷音輸入法\線上檢查是否有新版本.lnk" "$INSTDIR\Update.exe"
  CreateShortCut "$SMPROGRAMS\新酷音輸入法\解除安裝.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"

  Exec '"$SYSDIR\IME\Chewing\Installer.exe"'

  IfFileExists $APPDATA\Chewing\uhash.dat +3 0
  SetShellVarContext current
  ExecWait '"$TEMP\big52utf8.exe" $APPDATA\Chewing\hash.dat'

  ;Delete $TEMP\big52utf8.exe

  IfErrors 0 +2
    Call OnInstError

SectionEnd

Function un.onUninstSuccess
;  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功地從你的電腦移除。"
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "你確定要完全移除 $(^Name) ，其及所有的元件？" IDYES +2
  Abort
FunctionEnd

Section Uninstall

  FindWindow $0 "ChewingServer"
  SendMessage $0 ${WM_DESTROY} 0 0

  ExecWait '"$SYSDIR\IME\Chewing\Installer.exe" /uninstall'

  Delete "$SYSDIR\Chewing.ime"
  Delete "$SYSDIR\IME\Chewing\License.txt"
  Delete "$SYSDIR\IME\Chewing\statuswnd.bmp"
  Delete "$SYSDIR\IME\Chewing\ch_index.dat"
  Delete "$SYSDIR\IME\Chewing\dict.dat"
  Delete "$SYSDIR\IME\Chewing\fonetree.dat"
  Delete "$SYSDIR\IME\Chewing\ph_index.dat"
  Delete "$SYSDIR\IME\Chewing\us_freq.dat"
  Delete "$SYSDIR\IME\Chewing\Chewing.chm"
  Delete "$SYSDIR\IME\Chewing\Installer.exe"
  Delete "$SYSDIR\IME\Chewing\ChewingServer.exe"
  Delete "$SYSDIR\IME\Chewing\HashEd.exe"
  Delete "$SYSDIR\IME\Chewing\Update.exe"

  Delete "$SMPROGRAMS\新酷音輸入法\新酷音輸入法使用說明.lnk"
  Delete "$SMPROGRAMS\新酷音輸入法\本地詞庫編輯工具.lnk"
  Delete "$SMPROGRAMS\新酷音輸入法\解除安裝.lnk"

  RMDir "$SYSDIR\IME\Chewing"
  RMDir "$SMPROGRAMS\新酷音輸入法"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"

  Delete "$INSTDIR\uninst.exe"

  SetAutoClose true
SectionEnd
