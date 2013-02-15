set w3af_svn=c:\w3af-svn
set w3af_portable=D:\w3af_portable

xcopy /E /H /R %w3af_svn%\extras\windows_installer\gtk2-runtime\*.* %w3af_portable%\GTK\
del /S /Q %w3af_portable%\GTK\*.bat
del /S /Q %w3af_portable%\GTK\gtk2_runtime_uninst.exe
pause
