set python26=C:\Python26
set w3af_svn=..\python26

mkdir %w3af_svn%
xcopy /E /H /R %python26%\*.* %w3af_svn%\
del /Q /S %w3af_svn%\*.pyc
del /Q /S %w3af_svn%\*.pyo
del /Q /S %w3af_svn%\*.log
del /Q /S %w3af_svn%\*.bat
del /Q /S %w3af_svn%\Remove*.exe

pause

