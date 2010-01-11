set python25=C:\Python25-w3af_portable\Python25
set w3af_svn=..\python25

mkdir %w3af_svn%
xcopy /E /H /R %python25%\*.* %w3af_svn%\
del /Q /S %w3af_svn%\*.pyc
del /Q /S %w3af_svn%\*.pyo
del /Q /S %w3af_svn%\*.log
del /Q /S %w3af_svn%\*.bat
del /Q /S %w3af_svn%\Remove*.exe

pause

