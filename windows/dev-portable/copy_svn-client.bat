rem Descargar la version 1.5.x de svn-client http://www.open.collab.net/downloads/subversion/svn1.5.html
set svn_client=c:\"Archivos de programa"\
set w3af_svn=..\svn-client

xcopy /E /H /R %svn_client%\svn-client\*.* %w3af_svn%\svn-client\
pause
