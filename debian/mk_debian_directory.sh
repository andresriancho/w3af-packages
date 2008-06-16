#!/bin/bash
TRUNK='../../w3af'

UPSTREAM_RELEASE="0.0.0"
REVISION=$(svn info $TRUNK | grep Revision | cut -f 2 -d ' ')
VERSION="${UPSTREAM_RELEASE}svn${REVISION}"
BASE_DIR="w3af-${VERSION}"

# Just in case...
rm -rf ${BASE_DIR}
rm w3af_${VERSION}.orig.tar.gz

# copy trunk so we don't destroy our local copy
cp -Rp $TRUNK ${BASE_DIR}

# copy the manpage
cp -Rp ../manpage/w3af.1 ${BASE_DIR}

# remove the compiled python modules
find -L ${BASE_DIR} -name *.pyc | xargs rm

# remove the backup files
find -L ${BASE_DIR} -name '*~' | xargs rm

# remove the svn stuff
find -L ${BASE_DIR} -name .svn | xargs rm -rf

# remove plugins started with _
find w3af-0.0.0svn1305/plugins/ -name "_*.py" | grep -v init | xargs rm

# remove some paths and files that are created during the run
rm ${BASE_DIR}/.urllib2cache/ -rf
rm ${BASE_DIR}/.tmp/ -rf
rm ${BASE_DIR}/output-*.txt -rf
rm ${BASE_DIR}/sessions/* -rf
rm ${BASE_DIR}/w3af.e3* -rf

# This is not ready for distribution yet
rm ${BASE_DIR}/mozilla-extension/ -rf

# sanitize oHalberd
mv ${BASE_DIR}/plugins/discovery/oHalberd/Halberd ${BASE_DIR}/plugins/discovery/
rm -rf ${BASE_DIR}/plugins/discovery/oHalberd/
mv ${BASE_DIR}/plugins/discovery/Halberd ${BASE_DIR}/plugins/discovery/oHalberd

# Remove the debian offending stuff
rm -rf ${BASE_DIR}/extlib/pygoogle/
rm -rf ${BASE_DIR}/extlib/pywordnet/
rm -rf ${BASE_DIR}/plugins/discovery/wordnet.py
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

echo 'copy diffs'
cp -Rp dependencyCheck.py ${BASE_DIR}/core/controllers/misc/dependencyCheck.py

echo 'setting changelog'
sed -i "s/\[w3af_VERSION\]/$VERSION/" ${BASE_DIR}/debian/changelog

echo 'setting desktop'
sed -i "s/\[w3af_VERSION\]/$VERSION/" ${BASE_DIR}/debian/desktop

echo "The w3af directory inside ${BASE_DIR} contains all you need to create the .deb package."

