set PYTHONVERSION=c:\Python26
set PYGTK_INSTALLER="pygtk-2.12.1-2.win32-py2.6.exe"
set PYCAIRO_INSTALLER="pycairo-1.4.12-2.win32-py2.6.exe"
set PYGOBJECT_INSTALLER="pygobject-2.14.2-2.win32-py2.6.exe"
set PYOPENSSL_INSTALLER="pyOpenSSL-0.9.win32-py2.6.exe"
set CLUSTER_INSTALLER="cluster-1.1.1b3.win32.exe"

set PYWIN32_INSTALLER="pywin32-214.win32-py2.6.exe"
set PYPCAP_INSTALLER="pcap-1.1-scapy-20090720.win32-py2.6.exe"
set DNET_INSTALLER="dnet-1.12.win32-py2.5.exe"
set PYREADLINE_INSTALLER="pyreadline-1.5-win32-setup.exe"


call ..\prerequisite\%PYGTK_INSTALLER%
call ..\prerequisite\%PYCAIRO_INSTALLER%
call ..\prerequisite\%PYGOBJECT_INSTALLER%
call ..\prerequisite\%PYOPENSSL_INSTALLER%
REM ## No longer needed ##
REM copy ..\svn-client\libeay32.dll %PYTHONVERSION%\Lib\site-packages\OpenSSL\
call ..\prerequisite\%CLUSTER_INSTALLER%

REM ## SCAPY INSTALLATION ##
call ..\prerequisite\%PYWIN32_INSTALLER%
call ..\prerequisite\%PYPCAP_INSTALLER%
call ..\prerequisite\%DNET_INSTALLER%
call ..\prerequisite\%PYREADLINE_INSTALLER%

cd ..\extlib\fpconst-0.7.2\
call %PYTHONVERSION%\python.exe setup.py install

cd ..\pyPdf\
call %PYTHONVERSION%\python.exe setup.py install

cd ..\SOAPpy\
call %PYTHONVERSION%\python.exe setup.py install

cd ..\cluster\
call %PYTHONVERSION%\python.exe setup.py install

pause