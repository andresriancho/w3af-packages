;Copyright 2008,2009,2010 Ulises U. Cuñé
;This file is part of w3af Windows Installer.
;w3af is free software; you can redistribute it and/or modify
;it under the terms of the GNU General Public License as published by
;the Free Software Foundation version 2 of the License.
;w3ad windows installer is distributed in the hope that it will be useful,
;but WITHOUT ANY WARRANTY; without even the implied warranty of
;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;GNU General Public License for more details.
;
;You should have received a copy of the GNU General Public License
;along with w3af; if not, write to the Free Software
;Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
;
; General
!define /date RELEASE_VERSION "%d/%m/%Y"

; Define your application name
!define APPNAME "w3af"
!define APPNAMEANDVERSION "w3af 1.0 rc6"
!define REGKEY "Software\${APPNAME}"

; GUI Desktop link
!define W3AFGUILINK "$DESKTOP\w3af GUI.lnk"

; Main Install settings
Name "${APPNAME}"
InstallDir "$PROGRAMFILES\${APPNAME}"
InstallDirRegKey HKLM "${REGKEY}" ""

OutFile "${APPNAMEANDVERSION} setup.exe"

; Use compression
SetCompressor /SOLID LZMA
SetDatablockOptimize on

CRCCheck on
SetDateSave on
XPStyle off ; NO habilitar porque tiene problemas con la funcion SetCtlColors
ShowInstDetails hide

; Request application privileges for Windows Vista
RequestExecutionLevel admin

;--------------------------------
;Variables

Var StartMenuFolder

;--------------------------------
;Interface Settings

!define MUI_ABORTWARNING
!define MUI_ICON "image\w3af_gui_icon.ico"

!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "image\header_image.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP "image\splash_installer.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "image\splash_installer.bmp"

!define MUI_STARTMENUPAGE_REGISTRY_ROOT HKCU
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${REGKEY}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"

!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "Run w3af GUI"
!define MUI_FINISHPAGE_RUN_FUNCTION RunW3afGUI
!define MUI_FINISHPAGE_SHOWREADME
!define MUI_FINISHPAGE_SHOWREADME_TEXT "Show User Guide"
!define MUI_FINISHPAGE_SHOWREADME_FUNCTION ShowReleaseNotes
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_FINISHPAGE_LINK "Visit the w3af site for the latest news, FAQs and support"
!define MUI_FINISHPAGE_LINK_LOCATION "http://w3af.sf.net/"

# MEMENTO
!define MEMENTO_REGISTRY_ROOT ${MUI_STARTMENUPAGE_REGISTRY_ROOT}
!define MEMENTO_REGISTRY_KEY ${MUI_STARTMENUPAGE_REGISTRY_KEY}

;--------------------------------
;Include

!include "MUI2.nsh" ; Docs: http://nsis.sourceforge.net/Docs/Modern%20UI%202/Readme.html
!include "LogicLib.nsh"
!include "Memento.nsh"
!include "nsDialogs.nsh"
!include "AddToPath.nsh" ; http://nsis.sourceforge.net/Path_Manipulation ( & nmap )
!include "FileFunc.nsh"	; Macro RefreshShellIcons

;--------------------------------
; Pages

; Installer pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "GPL.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; Uninstall Pages
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

;--------------------------------
; Portable W3af
!include "WinMessages.nsh"
!include "FileFunc.nsh"

;--------------------------------
; Languages

!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Spanish"
!insertmacro MUI_RESERVEFILE_LANGDLL

;--------------------------------
; Version of installer
VIProductVersion "1.0.0.0"
VIAddVersionKey  /LANG=${LANG_ENGLISH} "ProductName" "w3af"
VIAddVersionKey  /LANG=${LANG_ENGLISH} "Comments" "Web Application Attack and Audit Framework - ${RELEASE_VERSION}"
VIAddVersionKey  /LANG=${LANG_ENGLISH} "CompanyName" "w3af team"
VIAddVersionKey  /LANG=${LANG_ENGLISH} "LegalTrademarks" "w3af team"
VIAddVersionKey  /LANG=${LANG_ENGLISH} "LegalCopyright" "GPL"
VIAddVersionKey  /LANG=${LANG_ENGLISH} "FileDescription" "Web Application Attack and Audit Framework - Installer."
VIAddVersionKey  /LANG=${LANG_ENGLISH} "FileVersion" "${APPNAMEANDVERSION}"

Function .onInit
	File /oname=$TEMP\splash.bmp "image\splash.bmp"	
	advsplash::show 3000 600 400 -1 $TEMP\splash

	; Prevent Multiple Instances
	System::Call 'kernel32::CreateMutexA(i 0, i 0, t "w3af_installer") i .r1 ?e'
	Pop $R0

	StrCmp $R0 0 +3
		MessageBox MB_OK|MB_ICONEXCLAMATION "The w3af installer is already running"
	Abort


	; Select Language
	!insertmacro MUI_LANGDLL_DISPLAY
	StrCpy $StartMenuFolder ${APPNAME}
	${MementoSectionRestore}
	;Uninstall before Install
	ReadRegStr $R0 HKLM "${REGKEY}" ""
	IfFileExists $R0\w3af_console.bat 0 install
		MessageBox MB_YESNO|MB_ICONQUESTION "You have to uninstall the previously installed version of w3af before installing this version. Do you want to uninstall the old version of w3af?" IDYES Desinstalar IDNO end
	Goto end
desinstalar:
	Exec $R0\uninstall.exe
end:
	Quit
install:

FunctionEnd

Function .onInstSuccess
	IfFileExists "$TEMP\splash.bmp" 0 +2
		Delete $TEMP\splash.bmp
	${MementoSectionSave}
FunctionEnd

############## Section W3AF ##############
${MementoSection} !"W3AF" SectionW3af

	SectionIn 1 RO
	SetDetailsPrint both
	SetOverwrite on
;	############## W3AF ##############
	SetOutPath "$INSTDIR\w3af\"
	File /r /x "*.pyc" /x "*.pyo" "..\w3af\*.*"
;	File /r /x "*.pyc" /x "*.pyo" "..\..\trunk\*.*"
	
;	############## GTK ##############
	SetOutPath "$INSTDIR\GTK\Graphviz"
	File /r /x ".svn" "Graphviz2.24\*.*"
	SetOutPath "$INSTDIR\GTK\GTK2-Runtime"
	File /r /x ".svn" "GTK2-Runtime\*.*"
	
	; Icons
	SetOutPath "$INSTDIR\GTK\"
	File "image\w3af_gui_icon.ico"
	File "image\w3af_script_icon.ico"

;	############## Python2.6.6 + pre-requisites ##############
	SetOutPath "$INSTDIR\python26\"
	File /r /x ".svn" "python26\*.*"

;	############## \ ##############
	SetOutPath "$INSTDIR\"
	
	; Manifest (WinVista/Win7)
	File "w3af_console.bat.manifest"
	File "w3af_gui.bat.manifest"

	
	; Create w3af commandline
	Push $INSTDIR\w3af_console.bat
	Call Writew3afConsole
	
	; Create w3af GUI
	Push $INSTDIR\w3af_gui.bat
	Call Writew3afGUI

	; Create w3af Theme
	Push $INSTDIR\w3af_theme.bat
	Call Writew3afTheme
	
	; Add w3af install dir to %PATH% (CURRENT_USER)
	Push $INSTDIR
	Call AddToPath
	
	; Copy .gtkrc-2.0 to %USERPROFILE%	
	Push "$PROFILE\.gtkrc-2.0"
	Call WriteGtkrc
	
${MementoSectionEnd}

Section -AsociationExtW3af
	; Script .w3af
	ReadRegStr $R0 HKCR ".w3af" ""
	StrCmp $R0 "W3AF.Script" 0 +2
	DeleteRegKey HKCR "W3AF.Script"
	
	WriteRegStr HKCR ".w3af" "" "W3AF.Script"
	WriteRegStr HKCR "W3AF.Script" "" "W3AF Script File"
	WriteRegStr HKCR "W3AF.Script\DefaultIcon" "" "$INSTDIR\GTK\w3af_script_icon.ico,0"

	; Open .w3af with w3af_console
	WriteRegStr HKCR "W3AF.Script\shell" "" "open"	;Default
	WriteRegStr HKCR "W3AF.Script\shell\open\command" "" '"$INSTDIR\w3af_console.bat" -s "%1"'

	; Edit .w3af with notepad.exe
	WriteRegStr HKCR "W3AF.Script\shell\edit\command" "" '"notepad.exe" "%1"'
	
	; Profile .pw3af
	ReadRegStr $R0 HKCR ".pw3af" ""
	StrCmp $R0 "W3AF.Profile" 0 +2
	DeleteRegKey HKCR "W3AF.Profile"

	WriteRegStr HKCR ".pw3af" "" "W3AF.Profile"
	WriteRegStr HKCR "W3AF.Profile" "" "W3AF Profile File"
	WriteRegStr HKCR "W3AF.Profile\DefaultIcon" "" "$INSTDIR\GTK\w3af_gui_icon.ico,0"

	; Open .pw3af with w3af_gui
	WriteRegStr HKCR "W3AF.Profile\shell" "" "open"	; Default
	WriteRegStr HKCR "W3AF.Profile\shell\open\command" "" '"$INSTDIR\w3af_gui.bat" -p "%1"'

	; Edit .pw3af with notepad.exe	
	WriteRegStr HKCR "W3AF.Profile\shell\edit\command" "" '"notepad.exe" "%1"'
	;After changing file associations, you can call this function to refresh the shell immediately.	
	${RefreshShellIcons}

SectionEnd

Section -MakeShortCuts
	!insertmacro MUI_STARTMENU_WRITE_BEGIN Application
	SetShellVarContext current

	#SetShellVarContext current
	SetOutPath "$INSTDIR"
	
	; Create shortcuts
	CreateShortCut "$DESKTOP\w3af Console.lnk" "$INSTDIR\w3af_console.bat" ""
	CreateShortCut "${W3AFGUILINK}" "$INSTDIR\w3af_gui.bat" "" "$INSTDIR\GTK\w3af_gui_icon.ico" 0 SW_SHOWNORMAL
	
	CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
	CreateShortCut "$SMPROGRAMS\$StartMenuFolder\w3af Console.lnk" "$INSTDIR\w3af_console.bat" ""
	CreateShortCut "$SMPROGRAMS\$StartMenuFolder\w3af GUI.lnk" "$INSTDIR\w3af_gui.bat" "" "$INSTDIR\GTK\w3af_gui_icon.ico" 0 SW_SHOWNORMAL
	CreateShortCut "$SMPROGRAMS\$StartMenuFolder\w3af Theme.lnk" "$INSTDIR\w3af_theme.bat" "" "$INSTDIR\GTK\gtk2-runtime\gtk.ico" 0 SW_SHOWNORMAL
	
	; Set Shortcut to Run As Administrator
	ShellLink::SetRunAsAdministrator "${W3AFGUILINK}"
	Pop $0
	DetailPrint "SetRunAsAdministrator: $0"
	DetailPrint ""

	# Restore the old out path
	SetOutPath "$SMPROGRAMS\$StartMenuFolder"
	
	;Readme EN
	CreateDirectory "$SMPROGRAMS\$StartMenuFolder\readme"
	CreateDirectory "$SMPROGRAMS\$StartMenuFolder\readme\EN"
	CreateShortCut "$SMPROGRAMS\$StartMenuFolder\readme\EN\w3af Users Guide (PDF).lnk" "$INSTDIR\w3af\readme\EN\w3af-users-guide.pdf"
	CreateShortCut "$SMPROGRAMS\$StartMenuFolder\readme\EN\w3af Users Guide (HTML).lnk" "$INSTDIR\w3af\readme\EN\w3af-users-guide.html"
	CreateShortCut "$SMPROGRAMS\$StartMenuFolder\readme\EN\w3af gtkUi User Guide (HTML).lnk" "$INSTDIR\w3af\readme\EN\gtkUiHTML\gtkUiUsersGuide.html"

	;Readme FR
	CreateDirectory "$SMPROGRAMS\$StartMenuFolder\readme\FR"
	CreateShortCut "$SMPROGRAMS\$StartMenuFolder\readme\FR\w3af Users Guide (PDF).lnk" "$INSTDIR\w3af\readme\FR\w3af-users-guide.pdf"
	CreateShortCut "$SMPROGRAMS\$StartMenuFolder\readme\FR\w3af Users Guide (HTML).lnk" "$INSTDIR\w3af\readme\FR\w3af-users-guide.html"

	CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Uninstall w3af.lnk" "$INSTDIR\uninstall.exe"
	!insertmacro MUI_STARTMENU_WRITE_END
	SectionEnd

Section -FinishSection
	WriteRegStr HKLM ${REGKEY} "" "$INSTDIR"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayName" "${APPNAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayIcon" "$INSTDIR\GTK\w3af_gui_icon.ico"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayVersion" "${APPNAMEANDVERSION}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "URLInfoAbout" "http://w3af.sf.net/"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "HelpLink" "http://w3af.sf.net/"
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoModify" "1"
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoRepair" "1"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString" "$INSTDIR\uninstall.exe"
	WriteUninstaller "$INSTDIR\uninstall.exe"

SectionEnd

${MementoSectionDone}

;--------------------------------
; Descriptions
; Modern install component descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	!insertmacro MUI_DESCRIPTION_TEXT ${SectionW3af} "w3af - Web Application Attack and Audit Framework."
!insertmacro MUI_FUNCTION_DESCRIPTION_END

; Uninstall section
Section un.Uninstall
	;ReadRegStr $StartMenuFolder HKCU ${REGKEY} MUI_STARTMENUPAGE_REGISTRY_VALUENAME
	!insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuFolder

	; Delete self
	Delete "$INSTDIR\uninstall.exe"	
	
	; Delete Shortcuts
	Delete "$DESKTOP\w3af Console.lnk"
	Delete "${W3AFGUILINK}"

	; Remove directories
	RMDir /r "$SMPROGRAMS\$StartMenuFolder"
	RMDir /r "$INSTDIR\"
	
	; Remove from registry...
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
	DeleteRegKey HKLM ${REGKEY}
	DeleteRegKey HKCU ${REGKEY}
	
	; Remove .w3af
	DeleteRegKey HKCR ".w3af"
	DeleteRegKey HKCR "W3AF.Script"
	
	; Remove .pw3af
	DeleteRegKey HKCR ".pw3af"
	DeleteRegKey HKCR "W3AF.Profile"

	; Likewise RemoveFromPath could be
	Push $INSTDIR
	Call un.RemoveFromPath
SectionEnd

Function ShowReleaseNotes	
	ExecShell "open" "$INSTDIR\w3af\readme\EN\w3af-users-guide.html"
FunctionEnd

Function RunW3afGUI
	SetOutPath "$INSTDIR"
	Exec '$INSTDIR\w3af_gui.bat'
FunctionEnd

; Create w3af_console.bat
Function Writew3afConsole
	Pop $R0 ; Output file
	Push $R9
	FileOpen $R9 $R0 w
	FileWrite $R9 "@echo off$\r$\n"
	FileWrite $R9 "set DIR=$INSTDIR$\r$\n"
	FileWrite $R9 "set PATH=%DIR%;%DIR%\Python26;%DIR%\w3af;%DIR%\Python26\DLLs;%PATH%$\r$\n"
	FileWrite $R9 "cd $\"%DIR%$\"$\r$\n"
	FileWrite $R9 "$\"%DIR%\Python26\python.exe$\" w3af\w3af_console %1 %2$\r$\n"
	FileClose $R9
	Pop $R9
FunctionEnd

; Create w3af_gui.bat
Function Writew3afGUI
	Pop $R0 ; Output file
	Push $R9
	FileOpen $R9 $R0 w
	FileWrite $R9 "@echo off$\r$\n"
	FileWrite $R9 "set DIR=$INSTDIR$\r$\n"
	FileWrite $R9 "set PATH=%DIR%;%DIR%\GTK\GTK2-Runtime\bin;%DIR%\GTK\Graphviz\bin;%DIR%\Python26;%DIR%\w3af;%DIR%\Python26\DLLs;%PATH%$\r$\n"
	FileWrite $R9 "cd $\"%DIR%$\"$\r$\n"
	FileWrite $R9 "$\"%DIR%\Python26\python.exe$\" w3af\w3af_gui %1 %2$\r$\n"
	FileClose $R9
	Pop $R9
FunctionEnd

; Create w3af_theme.bat
Function Writew3afTheme
	Pop $R0 ; Output file
	Push $R9
	FileOpen $R9 $R0 w
	FileWrite $R9 "@$\"%CD%\GTK\GTK2-Runtime\bin\gtk2_prefs.exe$\"$\r$\n"
	FileClose $R9
	Pop $R9
FunctionEnd

; Create .gtkrc-2.0
Function WriteGtkrc
	Pop $R0 ; Output file
	Push $R9
	FileOpen $R9 $R0 w
	FileWrite $R9 "# Auto-written by gtk2_prefs. Do not edit.$\r$\n"
	FileWrite $R9 "gtk-theme-name = $\"Clearlooks$\"$\r$\n"
	FileWrite $R9 "style $\"user-font$\"$\r$\n"
	FileWrite $R9 "{$\r$\n"
	FileWrite $R9 "font_name=$\"Sans 10$\"$\r$\n"
	FileWrite $R9 "}$\r$\n"
	FileWrite $R9 "widget_class $\"*$\" style $\"user-font$\"$\r$\n"
	FileClose $R9
	Pop $R9
FunctionEnd	

BrandingText "w3af - Andres Riancho / Installer - Ulises Cuñé, Javier Andalia"

; eof
