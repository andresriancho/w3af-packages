@echo off
set PATH=%CD%;%CD%\svn-client;%CD%\GTK\bin;%CD%\Python25;%CD%\w3af;%PATH%
%CD%\Python25\python.exe w3af\w3af_gui %1 %2
