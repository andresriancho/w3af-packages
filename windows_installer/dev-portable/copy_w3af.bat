set w3af_svn=D:\w3af-svn\
set w3af_portable=D:\w3af_portable

rem xcopy /E /H /R %w3af_svn%\branches\1.0\*.* %w3af_portable%\w3af\
svn-client\svn co https://w3af.svn.sourceforge.net/svnroot/w3af/branches/1.0 %w3af_portable%\w3af
pause
