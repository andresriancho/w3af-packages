; Script to generate installer w3af

; Define your application name
!define APPNAME "w3af"
!define APPNAMEANDVERSION "w3af beta 7"

; Main Install settings
Name "${APPNAMEANDVERSION}"
InstallDir "$PROGRAMFILES\w3af"

InstallDirRegKey HKLM "Software\${APPNAME}" ""
OutFile "w3af-svn-setup.exe"

; Use compression
SetCompressor BZip2

CRCCheck on

SetDateSave on

XPStyle on

ShowInstDetails show

;Request application privileges for Windows Vista
RequestExecutionLevel admin

; Modern interface settings
!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "Memento.nsh"

;--------------------------------
;Variables

Var StartMenuFolder


;--------------------------------
;Interface Settings

!define MUI_ABORTWARNING
!define MUI_ICON "w3af_gui_icon.ico"

!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "header_image.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP "splash_installer.bmp"

!define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\${APPNAME}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"

# MEMENTO
!define MEMENTO_REGISTRY_ROOT ${MUI_STARTMENUPAGE_REGISTRY_ROOT}
!define MEMENTO_REGISTRY_KEY ${MUI_STARTMENUPAGE_REGISTRY_KEY}

;--------------------------------
;Pages

; Install Pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "GPL.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder
!insertmacro MUI_PAGE_INSTFILES
;!define MUI_FINISHPAGE_RUN "$SMPROGRAMS\w3af\w3af GUI.lnk"
!define MUI_FINISHPAGE_SHOWREADME "$SMPROGRAMS\w3af\w3af Users Guide (HTML).lnk"
;!define MUI_FINISHPAGE_RUN_NOTCHECKED
!define MUI_FINISHPAGE_NOAUTOCLOSE
!insertmacro MUI_PAGE_FINISH

; Uninstall Pages
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH 

; Set languages (first is default language)
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_RESERVEFILE_LANGDLL



;---------------------;
; Original Installers ;
;---------------------;-------------------------------
;This files should be on the same directory than the script
!define PYGTK_INSTALLER "pygtk-2.12.1-2.win32-py2.5.exe" ; http://ftp.gnome.org/pub/GNOME/binaries/win32/pygtk/
!define PYCAIRO_INSTALLER "pycairo-1.4.12-1.win32-py2.5.exe" ; http://ftp.gnome.org/pub/GNOME/binaries/win32/pycairo/
!define PYGOBJECT_INSTALLER "pygobject-2.14.1-1.win32-py2.5.exe" ; http://ftp.gnome.org/pub/GNOME/binaries/win32/pygobject/
!define PYOPENSSL_INSTALLER "pyOpenSSL-0.7a2-py2.5.exe" ; http://pyopenssl.sourceforge.net/




Function .onInit

	;- w3af installer shouldn't include python
	;- w3af installer should check for python dependency, and if it fails
	;to find it tell the user to install it. Provide a link that the user
	;can follow in order to download python and exit.


	;Begin Detect Python
	Var /GLOBAL PYTHON_DIR
	StrCpy $PYTHON_DIR ""


	; Python Installation "For all User""
	EnumRegKey $0 HKLM Software\Python\PythonCore 0
	StrCmp $0 "" nopythonHKLM
	
	ReadRegStr $PYTHON_DIR HKLM Software\Python\PythonCore\$0\InstallPath ""
	
	Goto fin
	
nopythonHKLM:

	; Python Installation "Just for Me""
	EnumRegKey $0 HKCU Software\Python\PythonCore 0
	StrCmp $0 "" nopythonHKCU	
	
	ReadRegStr $PYTHON_DIR HKCU Software\Python\PythonCore\$0\InstallPath ""	
	
	;Workround & Bugfix for prerequisites. Set "For all User".
	WriteRegStr HKLM Software\Python\PythonCore\$0\InstallPath @ $PYTHON_DIR
	
	Goto fin
	
nopythonHKCU:
	MessageBox MB_OK "Open the python download page and exit the installer"
	
	ExecShell "open" "http://www.python.org/download/"

;For x86 processors:      http://www.python.org/ftp/python/2.5.2/python-2.5.2.msi
;For Win64-Itanium users: http://www.python.org/ftp/python/2.5.2/python-2.5.2.amd64.msi
;For Win64-AMD64 users:   http://www.python.org/ftp/python/2.5.2/python-2.5.2.ia64.msi
;msiexec /i python-2.5.2.msi ALLUSERS=1


	MessageBox MB_OK "Remember install python before use w3af"
	
	Quit
; End Detect Python


fin:	
	${MementoSectionRestore}
FunctionEnd


############## Section W3AF ##############
${MementoSection} !"w3af" SectionW3af

	SectionIn RO
	SetDetailsPrint both
	SetOverwrite on
	
	SetOutPath "$INSTDIR\"
	; BETA 6
	;File /r /x "*.pyc" "..\..\tags\beta6-release\*"
	
	; SVN TRUNK
	File /r /x "*.pyc" "..\..\trunk\*"
	File "w3af_gui_icon.ico"
	
	; Instalando extensiones que vienen con w3af
	SetOutPath "$INSTDIR\extlib\fpconst-0.7.2\"	
	nsExec::ExecToLog '"$PYTHON_DIR\python.exe" "$INSTDIR\extlib\fpconst-0.7.2\setup.py" install' ;http://research.warnes.net/projects/RStatServer/fpconst/index_html
	SetOutPath "$INSTDIR\extlib\pygoogle\"
	nsExec::ExecToLog  '"$PYTHON_DIR\python.exe" "$INSTDIR\extlib\pygoogle\setup.py" install' ;http://pygoogle.sourceforge.net/
	SetOutPath "$INSTDIR\extlib\pywordnet\"
	nsExec::ExecToLog '"$PYTHON_DIR\python.exe" "$INSTDIR\extlib\pywordnet\setup.py" install' ;http://pywordnet.sourceforge.net
	SetOutPath "$INSTDIR\extlib\pyPdf\"
	nsExec::ExecToLog  '"$PYTHON_DIR\python.exe" "$INSTDIR\extlib\pyPdf\setup.py" install' ;http://pybrary.net/pyPdf/
	SetOutPath "$INSTDIR\extlib\buzhug\"
	nsExec::ExecToLog '"$PYTHON_DIR\python.exe" "$INSTDIR\extlib\buzhug\setup.py" install' ;http://buzhug.sourceforge.net
	SetOutPath "$INSTDIR\extlib\SOAPpy\"
	nsExec::ExecToLog '"$PYTHON_DIR\python.exe" "$INSTDIR\extlib\SOAPpy\setup.py" install' ;http://pywebsvcs.sourceforge.net/
	
	
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application  
		SetShellVarContext current
		
		;Create shortcuts
		SetOutPath "$INSTDIR\"
		CreateShortCut "$DESKTOP\w3af Console.lnk" "$PYTHON_DIR\python.exe" "w3af"
		CreateShortCut "$DESKTOP\w3af GUI.lnk" "$PYTHON_DIR\python.exe" "w3af -g" "$INSTDIR\w3af_gui_icon.ico" 0 SW_SHOWNORMAL
		
		CreateDirectory "$SMPROGRAMS\w3af"
		CreateShortCut "$SMPROGRAMS\w3af\w3af Console.lnk" "$PYTHON_DIR\python.exe" "w3af"
		CreateShortCut "$SMPROGRAMS\w3af\w3af GUI.lnk" "$PYTHON_DIR\python.exe" "w3af -g" "$INSTDIR\w3af_gui_icon.ico" 0 SW_SHOWNORMAL
		CreateShortCut "$SMPROGRAMS\w3af\w3af Update.lnk" "$INSTDIR\w3af_update.bat"
		CreateShortCut "$SMPROGRAMS\w3af\w3af Users Guide (PDF).lnk" "$INSTDIR\readme\w3afUsersGuide.pdf"
		CreateShortCut "$SMPROGRAMS\w3af\w3af Users Guide (HTML).lnk" "$INSTDIR\readme\w3afUsersGuide.html"
		CreateShortCut "$SMPROGRAMS\w3af\Uninstall.lnk" "$INSTDIR\uninstall.exe"
	
	!insertmacro MUI_STARTMENU_WRITE_END
	
${MementoSectionEnd}


############## SVN Client ##############
${MementoSection} "svn" SectionSVN
	;http://subversion.tigris.org/project_packages.html
	SetDetailsPrint both
	SetOverwrite on
	
	SetOutPath "$INSTDIR\svn-client"
	File "svn-client\*.exe"
	
	SetOutPath "$INSTDIR\"
	File "svn-client\*.dll"	
	
	Push $INSTDIR\w3af_update.bat
	Call WriteUpdatew3af
	
${MementoSectionEnd}


############## GTK2 Runtime ##############
${MementoSection} "GTK2-Runtime" SectionGTK2Runtime
	;http://sourceforge.net/projects/gtk-win/

	SetDetailsPrint both
	SetOverwrite on
	
	SetOutPath "$INSTDIR"
	File  /r "gtk2-runtime\*"	
	
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
		SetDetailsPrint both
		SetOverwrite on
		SetOutPath "$INSTDIR\"		
		File ${PYGTK_INSTALLER}
		ExecWait '"$INSTDIR\${PYGTK_INSTALLER}"'
		;Delete $INSTDIR\${PYGTK_INSTALLER}
		
	${MementoSectionEnd}
	
	############## Pycairo ##############
	${MementoSection} "Pycairo" SectionPycairo
		SetDetailsPrint both
		SetOverwrite on
		SetOutPath "$INSTDIR"
		File ${PYCAIRO_INSTALLER}				
		ExecWait '"$INSTDIR\${PYCAIRO_INSTALLER}"'		
		;Delete $INSTDIR\${PYCAIRO_INSTALLER}
		
	${MementoSectionEnd}
	
	############## PyObject ##############
	${MementoSection} "PyObject" SectionPyObject				
		SetDetailsPrint both
		SetOverwrite on
		SetOutPath "$INSTDIR"	
		File ${PYGOBJECT_INSTALLER}	
		ExecWait '"$INSTDIR\${PYGOBJECT_INSTALLER}"'
		;Delete $INSTDIR\${PYGOBJECT_INSTALLER}
		
	${MementoSectionEnd}
	
	############## PyOpenSSL ##############
	${MementoSection} "PyOpenSSL" SectionPyOpenSSL				
		SetDetailsPrint both
		SetOverwrite on
		SetOutPath "$INSTDIR"	
		File ${PYOPENSSL_INSTALLER}		
		ExecWait '"$INSTDIR\${PYOPENSSL_INSTALLER}"'
		;Delete $INSTDIR\${PYOPENSSL_INSTALLER}
		
	${MementoSectionEnd}

SectionGroupEnd


Section -FinishSection

	WriteRegStr HKLM "Software\${APPNAME}" "" "$INSTDIR"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayName" "${APPNAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString" "$INSTDIR\uninstall.exe"
	WriteUninstaller "$INSTDIR\uninstall.exe"

SectionEnd



${MementoSectionDone}

;--------------------------------
; Descriptions
; Modern install component descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	!insertmacro MUI_DESCRIPTION_TEXT ${SectionW3af} "w3af - Web Application Attack and Audit Framework"
	!insertmacro MUI_DESCRIPTION_TEXT ${SectionSVN} "Svn client for updates"
	!insertmacro MUI_DESCRIPTION_TEXT ${SectionGTK2Runtime} "GTK2 Runtime"
	!insertmacro MUI_DESCRIPTION_TEXT ${SectionPyGTK} "PyGTK lets you to easily create programs with a graphical user interface using the Python programming language."
	!insertmacro MUI_DESCRIPTION_TEXT ${SectionPyCairo} "Pycairo is set of Python bindings for the cairo graphics library."
	!insertmacro MUI_DESCRIPTION_TEXT ${SectionPyObject} "Python Bindings for GObject."
	!insertmacro MUI_DESCRIPTION_TEXT ${SectionPyOpenSSL} "Python interface to the OpenSSL library"	
!insertmacro MUI_FUNCTION_DESCRIPTION_END


;Uninstall section
Section Uninstall

	;Remove from registry...
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
	DeleteRegKey HKLM "Software\${APPNAME}"
	DeleteRegKey HKCU "Software\${APPNAME}"

	; Delete self
	Delete "$INSTDIR\uninstall.exe"

	; Clean up w3af
	; No borrar 
	;Delete "$INSTDIR\*"
	

	!insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuFolder
	
	; Delete Shortcuts
	Delete "$DESKTOP\w3af Console.lnk"
	Delete "$DESKTOP\w3af GUI.lnk"
	Delete "$SMPROGRAMS\$StartMenuFolder\w3af Console.lnk"
	Delete "$SMPROGRAMS\$StartMenuFolder\w3af GUI.lnk"
	Delete "$SMPROGRAMS\$StartMenuFolder\w3af Users Guide (PDF).lnk"
	Delete "$SMPROGRAMS\$StartMenuFolder\w3af Users Guide (HTML).lnk"
	Delete "$SMPROGRAMS\$StartMenuFolder\w3af Update.lnk"
	Delete "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk"	
	

	; Remove remaining directories
	RMDir "$SMPROGRAMS\$StartMenuFolder"
	RMDir /r "$INSTDIR\"
	
SectionEnd



Function .onInstSuccess
	${MementoSectionSave}
FunctionEnd


; WriteUpdate_w3af
Function WriteUpdatew3af
	Pop $R0 ; Output file
	Push $R9
	FileOpen $R9 $R0 w
	FileWrite $R9 "@echo off$\r$\n"
	FileWrite $R9 "echo Updating the W3af...$\r$\n"
	FileWrite $R9 "$\"$INSTDIR\svn-client\svn.exe$\" cleanup$\r$\n"
	FileWrite $R9 "$\"$INSTDIR\svn-client\svn.exe$\" update$\r$\n"
	FileWrite $R9 "$\"$INSTDIR\svn-client\svn.exe$\" info$\r$\n"
	FileWrite $R9 "pause$\r$\n"
	FileClose $R9
	Pop $R9
FunctionEnd

; ----------------- CUSTOM POST (UN)INSTALL FUNCTIONS GTK RUNTIME

; WriteEnvBat
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


; WritePostInstall
Function WritePostInstall
	Pop $R0 ; Output file
	Push $R9
	FileOpen $R9 $R0 w
	FileWrite $R9 "@echo off$\r$\n"
	FileWrite $R9 "$\"$INSTDIR\bin\pango-querymodules.exe$\" > $\"$INSTDIR\etc\pango\pango.modules$\"$\r$\n"
	FileWrite $R9 "rem $\"$INSTDIR\bin\gdk-pixbuf-query-loaders.exe$\" > $\"$INSTDIR\etc\gtk-2.0\gdk-pixbuf.loaders$\"$\r$\n"
	FileWrite $R9 "$\"$INSTDIR\bin\gtk-query-immodules-2.0.exe$\" > $\"$INSTDIR\etc\gtk-2.0\gtk.immodules$\"$\r$\n"
	FileClose $R9
	Pop $R9
FunctionEnd

BrandingText "w3af - Andres Riancho / Installer - Ulises Cuñé(aka Ulises2k)"

; eof