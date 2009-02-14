;Copyright 2008, 2009 Ulises U. Cuñé
;
;Script to generate update w3af.
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
; 
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
VIProductVersion "1.0.0.0"
VIAddVersionKey  "ProductName" "w3af update"
VIAddVersionKey  "Comments" "Web Application Attack and Audit Framework"
VIAddVersionKey  "CompanyName" "w3af team"
VIAddVersionKey  "LegalTrademarks" "-"
VIAddVersionKey  "LegalCopyright" "GPL"
VIAddVersionKey  "FileDescription" "The project goal is to create a framework to find and exploit web application vulnerabilities that is easy to use and extend."
VIAddVersionKey  "FileVersion" "1.0 rc1"

; Request application privileges for Windows Vista
RequestExecutionLevel admin

Section -Run
	
	SetDetailsPrint both
	DetailPrint "Updating w3af to the latest SVN revision..."
	
	DetailPrint "svn cleanup"	
	ExecDos::exec 'svn-client\svn.exe cleanup'
	
	DetailPrint "svn update"
	ExecDos::exec /NOUNLOAD /DETAILED 'svn-client\svn.exe update'
	
SectionEnd
