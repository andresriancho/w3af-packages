;Copyright 2008,2009 Ulises U. Cuñé
;
;This file is part of w3af Windows Installer.
;
;w3af is free software; you can redistribute it and/or modify
;it under the terms of the GNU General Public License as published by
;the Free Software Foundation version 2 of the License.
;
;w3ad windows installer is distributed in the hope that it will be useful,
;but WITHOUT ANY WARRANTY; without even the implied warranty of
;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;GNU General Public License for more details.

;You should have received a copy of the GNU General Public License
;along with w3af; if not, write to the Free Software
;Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
;
;
;
; General
!define /date RELEASE_VERSION "%d/%m/%Y"

; Define your application name
!define APPNAME "w3af"
!define APPNAMEANDVERSION "w3af 1.0 rc 1"


; Main Install settings
Name "${APPNAMEANDVERSION}"
InstallDir "$PROGRAMFILES\w3af"
InstallDirRegKey HKLM "Software\${APPNAME}" ""
OutFile "w3af-1.0-rc1.exe"

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
;Include

!include "MUI2.nsh" ; Docs: http://nsis.sourceforge.net/Docs/Modern%20UI%202/Readme.html
!include "LogicLib.nsh"
!include "Memento.nsh"
!include "nsDialogs.nsh"
!include "AddToPath.nsh" ; http://nsis.sourceforge.net/Path_Manipulation ( & nmap )
!include "FileFunc.nsh"	; Macro RefreshShellIcons

;--------------------------------
;Variables

Var StartMenuFolder
Var PYTHON_DIR
Var Label2k


;--------------------------------
;Interface Settings

!define MUI_ABORTWARNING
!define MUI_ICON "image\w3af_gui_icon.ico"

!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "image\header_image.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP "image\splash_installer.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "image\splash_installer.bmp"

!define MUI_STARTMENUPAGE_REGISTRY_ROOT HKCU
!define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\${APPNAME}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"

!define MUI_FINISHPAGE_RUN "$SMPROGRAMS\$StartMenuFolder\w3af GUI.lnk"
!define MUI_FINISHPAGE_RUN_TEXT "Run W3af GUI"
!define MUI_FINISHPAGE_RUN_FUNCTION RunW3afGUI
!define MUI_FINISHPAGE_SHOWREADME "$SMPROGRAMS\$StartMenuFolder\w3af Users Guide (HTML).lnk"
!define MUI_FINISHPAGE_SHOWREADME_TEXT "Show User Guide"
!define MUI_FINISHPAGE_SHOWREADME_FUNCTION ShowReleaseNotes
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_FINISHPAGE_LINK "Visit the w3af site for the latest news, FAQs and support"
!define MUI_FINISHPAGE_LINK_LOCATION "http://w3af.sf.net/"


# MEMENTO
!define MEMENTO_REGISTRY_ROOT ${MUI_STARTMENUPAGE_REGISTRY_ROOT}
!define MEMENTO_REGISTRY_KEY ${MUI_STARTMENUPAGE_REGISTRY_KEY}

!define LINK_PYTHON "http://www.python.org/download/releases/2.5.4/"


;--------------------------------
; Pages

; Installer pages
!insertmacro MUI_PAGE_WELCOME
Page custom WindowDetectPython
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
; Asociation .w3af to w3af_console.bat
;
!insertmacro RefreshShellIcons

;--------------------------------
; Instalation Types

InstType "Minimal" #1
InstType "Full" #2

; Portable W3af
!include "WinMessages.nsh"
!include "FileFunc.nsh"

!insertmacro GetParameters
!insertmacro GetOptions


;--------------------------------
; Languages

!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Spanish"
!insertmacro MUI_RESERVEFILE_LANGDLL

; (English)
LangString PAGE_TITLE ${LANG_ENGLISH} "Prerequisite verification"
LangString PAGE_SUBTITLE ${LANG_ENGLISH} "In this step the installer verifies if the system has the necessary prerequisites for the w3af installation."
LangString PYTHON_FAILED ${LANG_ENGLISH} "The installer failed to detect a Python 2.5 installation in your system."
LangString PYTHON_DOWNLOAD ${LANG_ENGLISH} "Please download the version 2.5 of Python from the project homepage at "
LangString PYTHON_REMENBER ${LANG_ENGLISH} "Remember that you have to install Python 2.5 before using w3af"
LangString PYTHON_SUCCESSFULL ${LANG_ENGLISH} "Python 2.5 was successfully detected"
LangString PYTHON_DIRECTORY ${LANG_ENGLISH} "Python 2.5 installation found at: " ; $PYTHON_DIR"

; (Spanish)
LangString PAGE_TITLE ${LANG_SPANISH} "Verificación de pre-requisitos"
LangString PAGE_SUBTITLE ${LANG_SPANISH} "En este paso el instalador verifica si el sistema tiene los pre-requisitos necesarios para la instalación de w3af"
LangString PYTHON_FAILED ${LANG_SPANISH} "El instalador no ha detectado una instalacion de Python 2.5 en tu sistema."
LangString PYTHON_DOWNLOAD ${LANG_SPANISH} "Por favor descarga la version 2.5 de Python desde la homepage del proyecto en:"
LangString PYTHON_REMENBER ${LANG_SPANISH} "Recuerda que tienes que instalar Python 2.5 antes de utilizar w3af"
LangString PYTHON_SUCCESSFULL ${LANG_SPANISH} "Python 2.5 fue correctamente detectado"
LangString PYTHON_DIRECTORY ${LANG_SPANISH} "Instalación de Python 2.5 encontrada en: " ; $PYTHON_DIR"


;--------------------------------
; Version of installer
VIProductVersion "1.0.0.0"
VIAddVersionKey  /LANG=${LANG_ENGLISH} "ProductName" "w3af"
VIAddVersionKey  /LANG=${LANG_ENGLISH} "Comments" "Web Application Attack and Audit Framework - ${RELEASE_VERSION}"
VIAddVersionKey  /LANG=${LANG_ENGLISH} "CompanyName" "w3af team"
VIAddVersionKey  /LANG=${LANG_ENGLISH} "LegalTrademarks" "-"
VIAddVersionKey  /LANG=${LANG_ENGLISH} "LegalCopyright" "GPL"
VIAddVersionKey  /LANG=${LANG_ENGLISH} "FileDescription" "The project goal is to create a framework to find and exploit web application vulnerabilities that is easy to use and extend."
VIAddVersionKey  /LANG=${LANG_ENGLISH} "FileVersion" "${APPNAMEANDVERSION}"


;---------------------;
; Original Installers ;
;---------------------;-------------------------------
; This files should be on prerequisite directory on the script
!define PREREQUISITEDIR "prerequisite"

;Python 2.5
!define PYGTK_INSTALLER "pygtk-2.12.1-2.win32-py2.5.exe" ; http://ftp.gnome.org/pub/GNOME/binaries/win32/pygtk/
!define PYCAIRO_INSTALLER "pycairo-1.4.12-1.win32-py2.5.exe" ; http://ftp.gnome.org/pub/GNOME/binaries/win32/pycairo/
!define PYGOBJECT_INSTALLER "pygobject-2.14.1-1.win32-py2.5.exe" ; http://ftp.gnome.org/pub/GNOME/binaries/win32/pygobject/
!define PYOPENSSL_INSTALLER "pyOpenSSL-0.8.winxp32-py2.5.exe" ; http://pyopenssl.sourceforge.net/
!define CLUSTER_INSTALLER "cluster-1.1.1b3.win32.exe" ; http://sourceforge.net/projects/python-cluster/
!define GRAPHVIZ_INSTALLER "graphviz-2.20.3.msi" ; http://www.graphviz.org/

; Python 2.6 (Aun no usados)
!define PYGTK_INSTALLER_2_6 "pygtk-2.12.1-2.win32-py2.6.exe" ; http://ftp.gnome.org/pub/GNOME/binaries/win32/pygtk/
!define PYCAIRO_INSTALLER_2_6 "pycairo-1.4.12-2.win32-py2.6.exe" ; http://ftp.gnome.org/pub/GNOME/binaries/win32/pycairo/
!define PYGOBJECT_INSTALLER_2_6 "pygobject-2.14.2-2.win32-py2.6.exe" ; http://ftp.gnome.org/pub/GNOME/binaries/win32/pygobject/


; For Scapy
!define PYWIN32_INSTALLER "pywin32-212.win32-py2.5.exe" ; http://python.net/crew/mhammond/win32/Downloads.html
!define PYPCAP_INSTALLER "pcap-1.1-scapy.win32-py2.5.exe" ; http://www.secdev.org/projects/scapy/files/pcap-1.1-scapy.win32-py2.5.exe "special version for Scapy"
!define DNET_INSTALLER "dnet-1.12.win32-py2.5.exe" ; http://code.google.com/p/libdnet/
!define PYREADLINE_INSTALLER "pyreadline-1.5-win32-setup.exe" ; http://ipython.scipy.org/moin/PyReadline/Intro
!define WINPCAP_INSTALLER "WinPcap_4_0_2.exe" ; http://www.winpcap.org/

Function .onInit
	
	File /oname=$TEMP\splash.bmp "image\splash.bmp"	
	advsplash::show 3000 600 400 -1 $TEMP\splash

	; Prevent Multiple Instances
	System::Call 'kernel32::CreateMutexA(i 0, i 0, t "w3af_installer") i .r1 ?e'
		Pop $R0

	StrCmp $R0 0 +3
		MessageBox MB_OK|MB_ICONEXCLAMATION "The w3af installer is already running"
		Abort
	

	; PORTABLE W3AF
	
	; Obtener parametros
	${GetParameters} $R0
	StrCmp $R0 "" 0 +2
	Goto done
	
		; Obtener opcion ( /INSTALLPORTABLE= )
		ClearErrors
		${GetOptions} "$R0" "/INSTALLPORTABLE=" $R1
		IfErrors 0 +2
		MessageBox MB_OK "/INSTALLPORTABLE= [Target directory to decompress w3af into, for example C:\]" IDOK +3
		StrCpy $R0  '$R1'
		
		MessageBox MB_YESNO|MB_ICONQUESTION "¿Are you sure that you want to decompress the portable version of w3af into $R0?" IDYES portable IDNO installw3f
		
portable:
		
		MessageBox MB_OK|MB_ICONINFORMATION "Please click on [Accept] and wait until all files are decompressed..."
		
		; Variables 
		StrCpy "$INSTDIR" "$R0\w3af"
		StrCpy "$PYTHON_DIR" "$INSTDIR\PortablePython1.0"
		
		
		; PortablePython1.0+prerequisites
		SetOutPath "$INSTDIR\PortablePython1.0"
		File "PortablePython1.0\*"
		
		
		; W3af SVN TRUNK
		SetOutPath "$INSTDIR"
		File /r /x "*.pyc" "..\..\trunk\*"
		
		; Create w3af commandline
		Push $INSTDIR\w3af_console.bat
		Call Writew3af
		
		; Create w3af GUI
		Push $INSTDIR\w3af_gui.bat
		Call Writew3afGUI
		
		; w3af update
		Push $INSTDIR\w3af_update.bat
		Call WriteUpdatew3af
		
		File "w3af_update.exe"	
		
		
		; Manifest (WinVista)
		File "w3af_console.bat.manifest"
		File "w3af_gui.bat.manifest"
		File "w3af_update.bat.manifest"
		
		; DLL's (w3af_console)
		File "svn-client\libeay32.dll"
		File "svn-client\ssleay32.dll"
		
		
		; SVN Client
		SetOutPath "$INSTDIR\svn-client"
		File /x ".svn" /x "*.dll" "svn-client\*"
		
		
		; GTK
		SetOutPath "$INSTDIR\GTK"
		File /r "GTK\*"
		
		
		Call InstallExtLib
		
		MessageBox MB_OK|MB_ICONINFORMATION "The portable version of w3af has been decompressed into: $INSTDIR"
    
		Quit

  
installw3f:
	; Install W3af 
	
	!insertmacro MUI_LANGDLL_DISPLAY
	
	StrCpy $StartMenuFolder ${APPNAME}
	
	${MementoSectionRestore}
	
FunctionEnd


Function .onInstSuccess
	IfFileExists "$TEMP\splash.bmp" 0 +2
		Delete $TEMP\splash.bmp
	${MementoSectionSave}
FunctionEnd


############## Section W3AF ##############
${MementoSection} !"w3af" SectionW3af

	SectionIn 1 2 RO
	SetDetailsPrint both
	SetOverwrite on
	
	SetOutPath "$INSTDIR\"
	; BETA 6
	;File /r /x "*.pyc" "..\..\tags\beta6-release\*"
	
	; BETA 7
	;File /r /x "*.pyc" "..\..\tags\beta7-release\*"
	
	; SVN TRUNK
	File /r /x "*.pyc" "..\..\trunk\*"
	
	; Icons
	File "image\w3af_gui_icon.ico"
	File "image\w3af_script_icon.ico"
	
	; Manifest (WinVista)
	File "w3af_console.bat.manifest"
	File "w3af_gui.bat.manifest"
	
	; DLL's (w3af_console)
	File "svn-client\libeay32.dll"
	File "svn-client\ssleay32.dll"
	
	; Create w3af commandline
	Push $INSTDIR\w3af_console.bat
	Call Writew3af
	
	; Create w3af GUI
	Push $INSTDIR\w3af_gui.bat
	Call Writew3afGUI
	
	; Install extlib
	Call InstallExtLib
	
	; Add w3af install dir to %PATH% (CURRENT_USER)
  Push $INSTDIR
  Call AddToPath
	
${MementoSectionEnd}


############## SVN Client ##############
${MementoSection} "svn client" SectionSVN
	; http://subversion.tigris.org/getting.html#windows
	SectionIn 2
	SetDetailsPrint both
	SetOverwrite on
	
	SetOutPath "$INSTDIR\svn-client"
	File /x ".svn" /x "*.dll" "svn-client\*"
	
	; w3af update
	SetOutPath "$INSTDIR"
	File "w3af_update.exe"	
	File "w3af_update.bat.manifest"

	Push $INSTDIR\w3af_update.bat
	Call WriteUpdatew3af
	
	!insertmacro MUI_STARTMENU_WRITE_BEGIN Application
		SetOutPath $SMPROGRAMS\$StartMenuFolder
		SetShellVarContext current
		CreateShortCut "$SMPROGRAMS\$StartMenuFolder\w3af Update.lnk" "$INSTDIR\w3af_update.bat" "" "$INSTDIR\svn-client\svn.exe" 0 SW_SHOWNORMAL
	!insertmacro MUI_STARTMENU_WRITE_END
	

${MementoSectionEnd}


############## GTK2 Runtime ##############
${MementoSection} "GTK2-Runtime" SectionGTK2Runtime
	; http://sourceforge.net/projects/gtk-win/

	SectionIn 1 2
	SetDetailsPrint both
	SetOverwrite on
	
	SetOutPath "$INSTDIR"
	File  /r /x ".svn" "gtk2-runtime\*"
	File  /r /x ".svn" "svn-client\*.dll"	
	
	; Write $INSTDIR\gtk2-runtime\gtk2r-env.bat
	; This script sets the GTK environment variables
	DetailPrint "Generating $INSTDIR\gtk2-runtime\gtk2r-env.bat"
	Push $INSTDIR\gtk2-runtime\gtk2r-env.bat
	Call WriteEnvBat
	nsExec::ExecToLog '"$INSTDIR\gtk2-runtime\gtk2r-env.bat"'	


	; this script updates some config files, but it's unsafe
	; (gtk or pango may not work afterwards), so don't call it.
	Push $INSTDIR\gtk2-runtime\gtk-postinstall.bat
	Call WritePostInstall
	; update pango.modules, not working for now
	nsExec::ExecToLog '"$INSTDIR\gtk2-runtime\gtk-postinstall.bat"'
	
	
${MementoSectionEnd}


SectionGroup "w3af prerequisites"

############## PyGTK ##############
	${MementoSection} "PyGTK" SectionPyGTK
		SectionIn 1 2
		SetDetailsPrint both
		SetOverwrite on
		SetOutPath "$INSTDIR\${PREREQUISITEDIR}"
		File "${PREREQUISITEDIR}\${PYGTK_INSTALLER}"
		ExecWait '"$INSTDIR\${PREREQUISITEDIR}\${PYGTK_INSTALLER}"'		
	${MementoSectionEnd}
	
	############## Pycairo ##############
	${MementoSection} "Pycairo" SectionPycairo
		SectionIn 1 2
		SetDetailsPrint both
		SetOverwrite on
		SetOutPath "$INSTDIR\${PREREQUISITEDIR}"
		File "${PREREQUISITEDIR}\${PYCAIRO_INSTALLER}"
		ExecWait '"$INSTDIR\${PREREQUISITEDIR}\${PYCAIRO_INSTALLER}"'		
	${MementoSectionEnd}
	
	############## PyObject ##############
	${MementoSection} "PyObject" SectionPyObject
		SectionIn 1 2
		SetDetailsPrint both
		SetOverwrite on
		SetOutPath "$INSTDIR\${PREREQUISITEDIR}"	
		File "${PREREQUISITEDIR}\${PYGOBJECT_INSTALLER}"
		ExecWait '"$INSTDIR\${PREREQUISITEDIR}\${PYGOBJECT_INSTALLER}"'		
	${MementoSectionEnd}
	
	############## PyOpenSSL ##############
	${MementoSection} "PyOpenSSL" SectionPyOpenSSL
		SectionIn 1 2
		SetDetailsPrint both
		SetOverwrite on
		SetOutPath "$INSTDIR\${PREREQUISITEDIR}"
		File "${PREREQUISITEDIR}\${PYOPENSSL_INSTALLER}"
		ExecWait '"$INSTDIR\${PREREQUISITEDIR}\${PYOPENSSL_INSTALLER}"'	
	${MementoSectionEnd}
	
	############## python-cluster ##############
	${MementoSection} "python-cluster" SectionPythonCluster
		SectionIn 1 2
		SetDetailsPrint both
		SetOverwrite on
		SetOutPath "$INSTDIR\${PREREQUISITEDIR}"
		File "${PREREQUISITEDIR}\${CLUSTER_INSTALLER}"
		ExecWait '"$INSTDIR\${PREREQUISITEDIR}\${CLUSTER_INSTALLER}"'	
	${MementoSectionEnd}

	############## Graphiz ##############
	${MementoSection} "Graphiz" SectionGraphiz
		SectionIn 1 2
		SetDetailsPrint both
		SetOverwrite on
		SetOutPath "$INSTDIR\${PREREQUISITEDIR}"
		File "${PREREQUISITEDIR}\${GRAPHVIZ_INSTALLER}"
		ExecWait '"msiexec.exe" /i "$INSTDIR\${PREREQUISITEDIR}\${GRAPHVIZ_INSTALLER}"'
	${MementoSectionEnd}


	SectionGroup "Scapy-Win requisites"
	
		############## PyWin32 ##############
		${MementoSection} "PyWin32" SectionPyWin32
			SectionIn 1 2
			SetDetailsPrint both
			SetOverwrite on
			SetOutPath "$INSTDIR\${PREREQUISITEDIR}"
			File "${PREREQUISITEDIR}\${PYWIN32_INSTALLER}"
			ExecWait '"$INSTDIR\${PREREQUISITEDIR}\${PYWIN32_INSTALLER}"'	
		${MementoSectionEnd}
		
		############## PyPcap ##############
		${MementoSection} "PyPcap" SectionPyPcap
			SectionIn 1 2
			SetDetailsPrint both
			SetOverwrite on
			SetOutPath "$INSTDIR\${PREREQUISITEDIR}"
			File "${PREREQUISITEDIR}\${PYPCAP_INSTALLER}"
			ExecWait '"$INSTDIR\${PREREQUISITEDIR}\${PYPCAP_INSTALLER}"'	
		${MementoSectionEnd}
		
		############## libnet ##############
		${MementoSection} "libnet" SectionLibNet
			SectionIn 1 2
			SetDetailsPrint both
			SetOverwrite on
			SetOutPath "$INSTDIR\${PREREQUISITEDIR}"
			File "${PREREQUISITEDIR}\${DNET_INSTALLER}"
			ExecWait '"$INSTDIR\${PREREQUISITEDIR}\${DNET_INSTALLER}"'	
		${MementoSectionEnd}	
	
		############## PyReadline ##############
		${MementoSection} "PyReadline" SectionPyReadline
			SectionIn 1 2
			SetDetailsPrint both
			SetOverwrite on
			SetOutPath "$INSTDIR\${PREREQUISITEDIR}"
			File "${PREREQUISITEDIR}\${PYREADLINE_INSTALLER}"
			ExecWait '"$INSTDIR\${PREREQUISITEDIR}\${PYREADLINE_INSTALLER}"'	
		${MementoSectionEnd}
		
		############## WinPcap ##############
		${MementoSection} "WinPcap 4.0.2" SectionWinPcap
			SectionIn 1 2
			SetDetailsPrint both
			SetOverwrite on
			SetOutPath "$INSTDIR\${PREREQUISITEDIR}"
			File "${PREREQUISITEDIR}\${WINPCAP_INSTALLER}"
			ExecWait '"$INSTDIR\${PREREQUISITEDIR}\${WINPCAP_INSTALLER}"'	
		${MementoSectionEnd}
	
	SectionGroupEnd

SectionGroupEnd


Section -AsociationExtW3af
	
	; Script .w3af
	ReadRegStr $R0 HKCR ".w3af" ""
	StrCmp $R0 "W3AF.Script" 0 +2
		DeleteRegKey HKCR "W3AF.Script"
		
	WriteRegStr HKCR ".w3af" "" "W3AF.Script"
	WriteRegStr HKCR "W3AF.Script" "" "W3AF Script File"
	WriteRegStr HKCR "W3AF.Script\DefaultIcon" "" "$INSTDIR\w3af_script_icon.ico,0"

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
	WriteRegStr HKCR "W3AF.Profile\DefaultIcon" "" "$INSTDIR\w3af_gui_icon.ico,0"

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
		
		; Create shortcuts        
		CreateShortCut "$DESKTOP\w3af Console.lnk" "$INSTDIR\w3af_console.bat" ""
		CreateShortCut "$DESKTOP\w3af GUI.lnk" "$INSTDIR\w3af_gui.bat" "" "$INSTDIR\w3af_gui_icon.ico" 0 SW_SHOWNORMAL
		
		CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
		CreateShortCut "$SMPROGRAMS\$StartMenuFolder\w3af Console.lnk" "$INSTDIR\w3af_console.bat" ""
		CreateShortCut "$SMPROGRAMS\$StartMenuFolder\w3af GUI.lnk" "$INSTDIR\w3af_gui.bat" "" "$INSTDIR\w3af_gui_icon.ico" 0 SW_SHOWNORMAL
		
		;Readme EN
		CreateShortCut "$SMPROGRAMS\$StartMenuFolder\readme\EN\w3af Users Guide (PDF).lnk" "$INSTDIR\readme\EN\w3afUsersGuide.pdf"
		CreateShortCut "$SMPROGRAMS\$StartMenuFolder\readme\EN\w3af Users Guide (HTML).lnk" "$INSTDIR\readme\EN\w3afUsersGuide.html"
		CreateShortCut "$SMPROGRAMS\$StartMenuFolder\readme\EN\w3af gtkUi User Guide (HTML).lnk" "$INSTDIR\readme\EN\gtkUiHTML\gtkUiUsersGuide.html"
		;Readme FR
		CreateShortCut "$SMPROGRAMS\$StartMenuFolder\readme\FR\w3af Users Guide (PDF).lnk" "$INSTDIR\readme\FR\w3afUsersGuide_fr.pdf"
		CreateShortCut "$SMPROGRAMS\$StartMenuFolder\readme\FR\w3af Users Guide (HTML).lnk" "$INSTDIR\readme\FR\w3afUsersGuide_fr.html"
		
		CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Uninstall w3af.lnk" "$INSTDIR\uninstall.exe"				
	!insertmacro MUI_STARTMENU_WRITE_END
	
SectionEnd

Section -FinishSection
	
	WriteRegStr HKLM "Software\${APPNAME}" "" "$INSTDIR"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayName" "${APPNAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayIcon" "$INSTDIR\w3af_gui_icon.ico"
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
	!insertmacro MUI_DESCRIPTION_TEXT ${SectionSVN} "Svn client for updates."
	!insertmacro MUI_DESCRIPTION_TEXT ${SectionGTK2Runtime} "GTK2 Runtime. w3af GUI."
	!insertmacro MUI_DESCRIPTION_TEXT ${SectionPyGTK} "PyGTK lets you to easily create programs with a graphical user interface using the Python programming language."
	!insertmacro MUI_DESCRIPTION_TEXT ${SectionPyCairo} "Pycairo is set of Python bindings for the cairo graphics library."
	!insertmacro MUI_DESCRIPTION_TEXT ${SectionPyObject} "Python Bindings for GObject."
	!insertmacro MUI_DESCRIPTION_TEXT ${SectionPyOpenSSL} "Python interface to the OpenSSL library."
	!insertmacro MUI_DESCRIPTION_TEXT ${SectionPythonCluster} "python-cluster is a package that allows grouping a list of arbitrary objects into related groups (clusters)."
	!insertmacro MUI_DESCRIPTION_TEXT ${SectionPyWin32} "Python Extensions for Windows."	
	!insertmacro MUI_DESCRIPTION_TEXT ${SectionWinPcap} "WinPcap is the industry-standard tool for link-layer network access in Windows environments: it allows applications to capture and transmit network packets bypassing the protocol stack, and has additional useful features, including kernel-level packet filtering, a network statistics engine and support for remote packet capture."
	!insertmacro MUI_DESCRIPTION_TEXT ${SectionPyPcap} "Simplified object-oriented Python extension module for libpcap - the current tcpdump.org version, the legacy version shipping with some of the BSD operating systems, and the WinPcap port for Windows."
	!insertmacro MUI_DESCRIPTION_TEXT ${SectionLibNet} "Libdnet provides a simplified, portable interface to several low-level networking routines."
	!insertmacro MUI_DESCRIPTION_TEXT ${SectionPyReadline} "Pyreadline is based on UNC readline."	
	!insertmacro MUI_DESCRIPTION_TEXT ${SectionGraphiz} "Graph visualization is a way of representing structural information as diagrams of abstract graphs and networks."
!insertmacro MUI_FUNCTION_DESCRIPTION_END


; Uninstall section
Section Uninstall
	
	ReadRegStr $StartMenuFolder HKCU "Software\${APPNAME}" MUI_STARTMENUPAGE_REGISTRY_VALUENAME
	
	; Delete self
	Delete "$INSTDIR\uninstall.exe"	
	
	; Delete Shortcuts
	Delete "$DESKTOP\w3af Console.lnk"
	Delete "$DESKTOP\w3af GUI.lnk"

	; Remove directories
	RMDir /r "$SMPROGRAMS\$StartMenuFolder"
	RMDir /r "$INSTDIR\"
	
	; Remove from registry...
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
	DeleteRegKey HKLM "Software\${APPNAME}"
	DeleteRegKey HKCU "Software\${APPNAME}"
	
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


; ##########################################
; BEGIN CUSTOM PAGE
; ##########################################
Function WindowDetectPython
	; http://nsis.sourceforge.net/Docs/nsDialogs/Readme.html
	
  !insertmacro MUI_HEADER_TEXT $(PAGE_TITLE) $(PAGE_SUBTITLE)
	
	nsDialogs::Create /NOUNLOAD 1018
	Pop $0

	;${NSD_Create*} x y width height text
	
	Call DetectPython
	
	StrCmp $PYTHON_DIR "" 0 YesPython	

	${NSD_CreateLabel} 0 0 100% 12u $(PYTHON_FAILED)
	Pop $Label2k

	${NSD_CreateLabel} 0 23u 100% 13u $(PYTHON_DOWNLOAD)
	Pop $Label2k
	
  ${NSD_CreateLabel} 0 30u 100% 13u "http://www.python.org/download/releases/2.5.4/"
	Pop $Label2k
	SetCtlColors $Label2k 0x0000FF "transparent"
	GetFunctionAddress $0 LinkPython
	nsDialogs::OnClick /NOUNLOAD $Label2k $0
	

	Goto fin
	
	
YesPython:
	${NSD_CreateLabel} 0 0 100% 12u $(PYTHON_SUCCESSFULL)
	Pop $Label2k

	${NSD_CreateLabel} 0 23u 100% -13u "$(PYTHON_DIRECTORY) $PYTHON_DIR"
	Pop $Label2k
	
	
fin:

	
	nsDialogs::Show
	
	
	StrCmp $PYTHON_DIR "" 0 +3	
		MessageBox MB_OK|MB_ICONINFORMATION  $(PYTHON_REMENBER)
		Quit
	
FunctionEnd

Function LinkPython
	
  Pop $0
	ExecShell open ${LINK_PYTHON}
	
FunctionEnd

; DetectPython
Function DetectPython
	
	; Python Installation "For all User""
	; @=C:\Python25
	; o
	; Predeterminado=C:\Python25
	StrCpy $PYTHON_DIR ""
	StrCpy $0 0
	StrCpy $1 0
	
	; BE CAREFULL IN CHANGE IT
loopHKLM:
	EnumRegKey $0 HKLM Software\Python\PythonCore $1	
  StrCmp $0 "" doneloopHKLM 0
	ReadRegStr $PYTHON_DIR HKLM Software\Python\PythonCore\$0\InstallPath ""	
	IfFileExists $PYTHON_DIR\python.exe 0 +2
	StrCmp $0 "2.5" done 0
	StrCpy $PYTHON_DIR ""
  IntOp $1 $1 + 1
	IntCmp $1 10 doneloopHKLM 0
  Goto loopHKLM
doneloopHKLM:

	
	StrCpy $1 0
loopHKCU:
	EnumRegKey $0 HKCU Software\Python\PythonCore $1
  StrCmp $0 "" doneloopHKCU 0
	ReadRegStr $PYTHON_DIR HKCU Software\Python\PythonCore\$0\InstallPath ""
	IfFileExists $PYTHON_DIR\python.exe 0 +2
	StrCmp $0 "2.5" doneloopHKCU 0
	StrCpy $PYTHON_DIR ""
  IntOp $1 $1 + 1
	IntCmp $1 10 doneloopHKCU 0
  Goto loopHKCU
doneloopHKCU:

	; Workround & Bugfix for prerequisites. Set "For all User".
	WriteRegStr HKLM Software\Python\PythonCore\$0\InstallPath "" $PYTHON_DIR

done:
	
FunctionEnd

; ##########################################
; END CUSTOM PAGE
; ##########################################

Function ShowReleaseNotes
	ExecShell "open" "$INSTDIR\readme\w3afUsersGuide.html"
FunctionEnd

Function RunW3afGUI
	SetOutPath "$INSTDIR"
	Exec '$INSTDIR\w3af_gui.bat'
FunctionEnd

; Create w3af Update
Function WriteUpdatew3af
	Pop $R0 ; Output file
	Push $R9
	FileOpen $R9 $R0 w
	FileWrite $R9 "@echo off$\r$\n"
	FileWrite $R9 "echo Updating the W3af...$\r$\n"
	FileWrite $R9 "$\"$INSTDIR\svn-client\svn.exe$\" cleanup $\"$INSTDIR$\"$\r$\n"
	FileWrite $R9 "$\"$INSTDIR\svn-client\svn.exe$\" update $\"$INSTDIR$\"$\r$\n"
	FileWrite $R9 "pause$\r$\n"
	FileClose $R9
	Pop $R9
FunctionEnd

; Create w3af_console.bat
Function Writew3af
	Pop $R0 ; Output file
	Push $R9
	FileOpen $R9 $R0 w
	FileWrite $R9 "@echo off$\r$\n"
	FileWrite $R9 "set PATH=%PATH%;%CD%\GTK\bin;%CD%;%CD%\svn-client"
	FileWrite $R9 "cd $\"$INSTDIR$\"$\r$\n"
	FileWrite $R9 "$\"$PYTHON_DIR\python.exe$\" w3af_console %1 %2$\r$\n"
	FileClose $R9
	Pop $R9
FunctionEnd

; Create w3af_gui.bat
Function Writew3afGUI
	Pop $R0 ; Output file
	Push $R9
	FileOpen $R9 $R0 w
	FileWrite $R9 "@echo off$\r$\n"
	FileWrite $R9 "set PATH=%PATH%;%CD%\GTK\bin;%CD%;%CD%\svn-client$\r$\n"
	FileWrite $R9 "cd $\"$INSTDIR$\"$\r$\n"
	FileWrite $R9 "$\"$PYTHON_DIR\python.exe$\" w3af_gui %1 %2$\r$\n"
	FileClose $R9
	Pop $R9
FunctionEnd


Function InstallExtLib
	; Instalando extensiones que vienen con w3af
	SetOutPath "$INSTDIR\extlib\fpconst-0.7.2\"
	nsExec::ExecToLog '"$PYTHON_DIR\python.exe" "$INSTDIR\extlib\fpconst-0.7.2\setup.py" install' ;http://research.warnes.net/projects/RStatServer/fpconst/index_html
	SetOutPath "$INSTDIR\extlib\pygoogle\"
	nsExec::ExecToLog  '"$PYTHON_DIR\python.exe" "$INSTDIR\extlib\pygoogle\setup.py" install' ;http://pygoogle.sourceforge.net/
	SetOutPath "$INSTDIR\extlib\pywordnet\"
	nsExec::ExecToLog '"$PYTHON_DIR\python.exe" "$INSTDIR\extlib\pywordnet\setup.py" install' ;http://pywordnet.sourceforge.net
	SetOutPath "$INSTDIR\extlib\pyPdf\"
	nsExec::ExecToLog  '"$PYTHON_DIR\python.exe" "$INSTDIR\extlib\pyPdf\setup.py" install' ;http://pybrary.net/pyPdf/
	SetOutPath "$INSTDIR\extlib\SOAPpy\"
	nsExec::ExecToLog '"$PYTHON_DIR\python.exe" "$INSTDIR\extlib\SOAPpy\setup.py" install' ;http://pywebsvcs.sourceforge.net/
	SetOutPath "$INSTDIR\extlib\cluster\"
	nsExec::ExecToLog '"$PYTHON_DIR\python.exe" "$INSTDIR\extlib\cluster\setup.py" install' ;http://python-cluster.sourceforge.net/
	SetOutPath "$INSTDIR\extlib\jsonpy\"
	nsExec::ExecToLog '"$PYTHON_DIR\python.exe" "$INSTDIR\extlib\jsonpy\setup.py" install' ;http://sourceforge.net/projects/json-py/
	
	; Install Scapy-Win	
	SetOutPath "$PYTHON_DIR\Lib\site-packages"
	File "extlib\scapy-windows\scapy.py"
FunctionEnd

; ----------------- CUSTOM POST (UN)INSTALL FUNCTIONS GTK RUNTIME
; WriteEnvBat GTK Runtime
Function WriteEnvBat
	Pop $R0 ; Output file
	Push $R9
	FileOpen $R9 $R0 w
	FileWrite $R9 "@set GTK2R_PREFIX=$INSTDIR$\r$\n"
	FileWrite $R9 "$\r$\n"
	FileWrite $R9 "@echo Setting environment variables for GTK2-Runtime.$\r$\n"
	FileWrite $R9 "@echo.$\r$\n"
	FileWrite $R9 "$\r$\n"
	FileWrite $R9 "@echo set PATH=%GTK2R_PREFIX%;%%PATH%%$\r$\n"
	FileWrite $R9 "@set PATH=%GTK2R_PREFIX%;%PATH%$\r$\n"
	FileWrite $R9 "$\r$\n"
	FileWrite $R9 "@echo.$\r$\n"
	FileClose $R9
	Pop $R9
FunctionEnd


; WritePostInstall GTK Runtime
Function WritePostInstall
	Pop $R0 ; Output file
	Push $R9
	FileOpen $R9 $R0 w
	FileWrite $R9 "@echo off$\r$\n"
	FileWrite $R9 "$\"$INSTDIR\bin\pango-querymodules.exe$\" > $\"$INSTDIR\etc\pango\pango.modules$\"$\r$\n"
	FileWrite $R9 "$\"$INSTDIR\bin\gtk-query-immodules-2.0.exe$\" > $\"$INSTDIR\etc\gtk-2.0\gtk.immodules$\"$\r$\n"
	FileClose $R9
	Pop $R9
FunctionEnd

BrandingText "w3af - Andres Riancho / Installer - Ulises Cuñé (Ulises2k)"

; eof
