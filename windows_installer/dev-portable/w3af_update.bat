@echo off
echo Updating w3af to the latest SVN revision...
echo svn cleanup
svn-client\svn.exe cleanup w3af
echo svn update
svn-client\svn.exe update w3af
svn-client\svn.exe info w3af
pause
