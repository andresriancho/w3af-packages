set w3af_portable=d:\w3af_portable
set python25=..\Python25
set Graphviz=..\Graphviz2.20
set Gtk2-runtime=..\GTK2-Runtime
set svn-client=..\svn-client
set w3af=..\..\..\trunk

mkdir %w3af_portable%\Python25
xcopy /E /H /R %python25%\*.* %w3af_portable%\Python25

mkdir %w3af_portable%\GTK
xcopy /E /H /R %Graphviz%\*.* %w3af_portable%\GTK
xcopy /E /H /R %Gtk2-runtime%\*.* %w3af_portable%\GTK

mkdir %w3af_portable%\svn-client
xcopy /E /H /R %svn-client%\*.* %w3af_portable%\svn-client

mkdir %w3af_portable%\w3af
xcopy /E /H /R %w3af%\*.* %w3af_portable%\w3af

xcopy /E /H /R w3af_console.bat %w3af_portable%\
xcopy /E /H /R w3af_gui.bat %w3af_portable%\
xcopy /E /H /R w3af_update.bat %w3af_portable%\

xcopy /E /H /R w3af_console.bat.manifest %w3af_portable%\
xcopy /E /H /R w3af_gui.bat.manifest %w3af_portable%\
xcopy /E /H /R w3af_update.bat.manifest %w3af_portable%\

pause