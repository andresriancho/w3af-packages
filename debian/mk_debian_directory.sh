#!/bin/bash
TRUNK='../../w3af'

if test ! -x /usr/bin/dpkg  ; then echo "Is this a Debian-derivate? This scripts use specific tools like dpkg and debhelper, which are only available in a Debian-derivate. Sorry..." ; return 1; fi

echo "Checking if you have needed packages to build w3af.deb"
installed=$(dpkg -l debhelper fakeroot make subversion python-support | grep ^ii |awk '{print $2}')

UPSTREAM_RELEASE="0.0.0"
REVISION=$(svn info $TRUNK | grep Revision | cut -f 2 -d ' ')
VERSION="${UPSTREAM_RELEASE}svn${REVISION}"
BASE_DIR="w3af-${VERSION}"

# Just in case...
rm -rf ${BASE_DIR} > /dev/null 2>&1 && echo "removing ${BASE_DIR}"
rm w3af_${VERSION}.orig.tar.gz > /dev/null 2>&1 && echo "removing w3af_${VERSION}.orig.tar.gz"

# copy trunk so we don't destroy our local copy
cp -Rp $TRUNK ${BASE_DIR} && echo ""

# copy the manpage
cp -Rp ../manpage/w3af.1 ${BASE_DIR} && echo "Coping the manpage"

echo -n "Removing: "
# remove the compiled python modules
(find ${BASE_DIR} -name *.pyc | xargs rm) > /dev/null 2>&1 && echo -n "*.pyc, "
# remove the backup files
(find ${BASE_DIR} -name '*~' | xargs rm) > /dev/null 2>&1 && echo -n "~, "
# remove the svn stuff
(find ${BASE_DIR} -name .svn | xargs rm -rf) > /dev/null 2>&1 && echo -n ".svn, "
# remove plugins started with _
(find ${BASE_DIR}/plugins/ -name "_*.py" | grep -v init | xargs rm) > /dev/null 2>&1 && echo -n "obsolete plugins, "
# remove some paths and files that are created during the run
((rm ${BASE_DIR}/.urllib2cache/ -rf) > /dev/null 2>&1 || 
(rm ${BASE_DIR}/.tmp/ -rf) > /dev/null 2>&1 ||
(rm ${BASE_DIR}/output-*.txt -rf) > /dev/null 2>&1 ||
#(rm ${BASE_DIR}/sessions/* -rf) > /dev/null 2>&1 ||
(rm ${BASE_DIR}/w3af.e3* -rf) > /dev/null 2>&1) && echo -n "paths created during the run, " 
echo "-"

# This is not ready for distribution yet
(rm ${BASE_DIR}/mozilla-extension/ -rf)  > /dev/null 2>&1 

# sanitize oHalberd
find ${BASE_DIR}/plugins/discovery/oHalberd/* -type d | grep -v "plugins/discovery/oHalberd/Halberd" | xargs rm -rf
rm ${BASE_DIR}/plugins/discovery/oHalberd/* > /dev/null 2>&1 

# Remove the debian offending stuff
rm -rf ${BASE_DIR}/extlib/pygoogle/
rm -rf ${BASE_DIR}/extlib/pywordnet/
rm -rf ${BASE_DIR}/plugins/discovery/wordnet.py
rm -rf ${BASE_DIR}/plugins/discovery/
rm -rf ${BASE_DIR}/tools/

# And remove the things that are already inside debian as packages
# python-scapy
rm -rf ${BASE_DIR}/extlib/scapy/
# python-pypdf
rm -rf ${BASE_DIR}/extlib/pyPdf/
# python-beautifulsoup
rm -rf ${BASE_DIR}/extlib/BeautifulSoup.py
# python-json
rm -rf ${BASE_DIR}/extlib/jsonpy/
# python-fpconst
rm -rf ${BASE_DIR}/extlib/fpconst*/
# python-soappy
rm -rf ${BASE_DIR}/extlib/SOAPpy/
# python-buzhug
rm -rf ${BASE_DIR}/extlib/buzhug/

#fixing permitions
find ${BASE_DIR} -type d -exec chmod 755 {} \;
find ${BASE_DIR} -type f -exec chmod 644 {} \;
chmod +x ${BASE_DIR}/w3af

echo "creating w3af_${VERSION}.orig.tar.gz"
tar zcf w3af_${VERSION}.orig.tar.gz ${BASE_DIR}

echo '~/debian'
cp -r trunk/debian ${BASE_DIR}/
(find ${BASE_DIR}/debian -name .svn | xargs rm -rf) > /dev/null 2>&1 && echo -n ".svn, "

echo 'copy diffs'
cp -Rp dependencyCheck.py ${BASE_DIR}/core/controllers/misc/dependencyCheck.py

echo 'setting changelog'
sed -i "s/\[w3af_VERSION\]/$VERSION/" ${BASE_DIR}/debian/changelog

echo 'setting desktop'
sed -i "s/\[w3af_VERSION\]/$VERSION/" ${BASE_DIR}/debian/desktop

echo "The w3af directory inside ${BASE_DIR} contains all you need to create the .deb package."

echo "Building the package..."
cd ${BASE_DIR} 
#fakeroot ./debian/rules binary   > /dev/null 2>&1  && echo ' done.'
