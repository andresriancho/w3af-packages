set w3af_portable=C:\extras\windows_installer\w3af_portable
set python26=..\Python26
set Graphviz=..\Graphviz2.24
set Gtk2-runtime=..\GTK2-Runtime
set svn-client=..\svn-client
set w3af=..\w3af

mkdir %w3af_portable%\Python26
xcopy /E /H /R %python26%\*.* %w3af_portable%\Python26

mkdir %w3af_portable%\GTK
mkdir %w3af_portable%\GTK\Graphviz
xcopy /E /H /R %Graphviz%\*.* %w3af_portable%\GTK\Graphviz
mkdir %w3af_portable%\GTK\GTK2-Runtime
xcopy /E /H /R %Gtk2-runtime%\*.* %w3af_portable%\GTK\GTK2-Runtime

REM ## WE DON'T USE SVN-CLIENT ANYMORE ##
REM mkdir %w3af_portable%\svn-client
REM xcopy /E /H /R %svn-client%\*.* %w3af_portable%\svn-client

mkdir %w3af_portable%\w3af
xcopy /E /H /R %w3af%\*.* %w3af_portable%\w3af

xcopy /E /H /R w3af_console.bat %w3af_portable%\
xcopy /E /H /R w3af_gui.bat %w3af_portable%\
xcopy /E /H /R w3af_update.bat %w3af_portable%\

xcopy /E /H /R w3af_console.bat.manifest %w3af_portable%\
xcopy /E /H /R w3af_gui.bat.manifest %w3af_portable%\
xcopy /E /H /R w3af_update.bat.manifest %w3af_portable%\

pause