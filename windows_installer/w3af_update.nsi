; Script to generate update w3af

;General Attributes
SetCompressor /SOLID lzma
SetDatablockOptimize on
CRCCheck on
Name "w3af update"
BrandingText "Andres Riancho - Ulises Cuñé"
OutFile "w3af_update.exe"
AutoCloseWindow false
ShowInstDetails show

;Icon main.ico
XPStyle on

;Insertar Informacion de la Version en el Instalador
VIProductVersion "0.7.0.0"
VIAddVersionKey  "ProductName" "w3af update"
VIAddVersionKey  "Comments" "Web Application Attack and Audit Framework"
VIAddVersionKey  "CompanyName" "-"
VIAddVersionKey  "LegalTrademarks" "-"
VIAddVersionKey  "LegalCopyright" "GPL"
VIAddVersionKey  "FileDescription" "The project goal is to create a framework to find and exploit web application vulnerabilities that is easy to use and extend."
VIAddVersionKey  "FileVersion" "svn later Beta 7"

; Request application privileges for Windows Vista
RequestExecutionLevel admin

Section -Run
	
	SetDetailsPrint both
	DetailPrint "w3af updating..."
	
	DetailPrint "svn cleanup"
	nsExec::ExecToLog '"svn-client\svn.exe" cleanup'
	
	DetailPrint "svn update"
	nsExec::ExecToLog '"svn-client\svn.exe" update'
	
SectionEnd
