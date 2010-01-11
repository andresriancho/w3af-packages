set PYTHON25=c:\Python25

set PYGTK_INSTALLER="pygtk-2.12.1-3.win32-py2.5.exe"
set PYCAIRO_INSTALLER="pycairo-1.4.12-2.win32-py2.5.exe"
set PYGOBJECT_INSTALLER="pygobject-2.14.2-2.win32-py2.5.exe"
set PYOPENSSL_INSTALLER="pyOpenSSL-0.8a1.winxp32-py2.5.exe"
set CLUSTER_INSTALLER="cluster-1.1.1b3.win32.exe"

set PYWIN32_INSTALLER="pywin32-212.win32-py2.5.exe"
set PYPCAP_INSTALLER="pcap-1.1-scapy.win32-py2.5.exe"
set DNET_INSTALLER="dnet-1.12.win32-py2.5.exe"
set PYREADLINE_INSTALLER="pyreadline-1.5-win32-setup.exe"


call ..\prerequisite\%PYGTK_INSTALLER%
call ..\prerequisite\%PYCAIRO_INSTALLER%
call ..\prerequisite\%PYGOBJECT_INSTALLER%
call ..\prerequisite\%PYOPENSSL_INSTALLER%
copy ..\svn-client\libeay32.dll %PYTHON25%\Lib\site-packages\OpenSSL\
call ..\prerequisite\%CLUSTER_INSTALLER%

copy ..\extlib\scapy-windows\scapy.py %PYTHON25%\Lib\site-packages\
call ..\prerequisite\%PYWIN32_INSTALLER%
call ..\prerequisite\%PYPCAP_INSTALLER%
call ..\prerequisite\%DNET_INSTALLER%
call ..\prerequisite\%PYREADLINE_INSTALLER%

cd ..\extlib\fpconst-0.7.2\
call %PYTHON25%\python.exe setup.py install

cd ..\pygoogle\
call %PYTHON25%\python.exe setup.py install

cd ..\pyPdf\
call %PYTHON25%\python.exe setup.py install

cd ..\SOAPpy\
call %PYTHON25%\python.exe setup.py install

cd ..\cluster\
call %PYTHON25%\python.exe setup.py install

pause