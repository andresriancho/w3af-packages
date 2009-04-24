#!/bin/bash
 
# Argument = -t test -r server -p password -v

usage()
{
cat << EOF
usage: $0 -d <diretory> -v <upstream_version>

This script builds a deb package

OPTIONS:
   -h      Show this message
   -d      Diretory with the source
   -v      Upstream version
EOF
}

DIR=
UPSTREAM_RELEASE=

while getopts "hd:v:" OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         d)
             DIR=$OPTARG
             ;;
         v)
	     UPSTREAM_RELEASE=$OPTARG
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

if [[ -z $DIR ]] || [[ -z $UPSTREAM_RELEASE ]]
then
     usage
     exit 1
fi

REVISION=$(svn info $DIR | grep Revision | cut -f 2 -d ' ' 2> /dev/null)
if [[ -z $REVISION ]]
then
      VERSION="${UPSTREAM_RELEASE}"
else
      VERSION="${UPSTREAM_RELEASE}svn${REVISION}"
fi

BASE_DIR="w3af-${VERSION}"
echo ····· Building $BASE_DIR ·····

if test ! -x /usr/bin/dpkg  ; then echo "Is this a Debian-derivate? This scripts use specific tools like dpkg and debhelper, which are only available in a Debian-derivate. Sorry..." ; return 1; fi

echo "Checking if you have needed packages to build w3af.deb"
installed=$(dpkg -l debhelper fakeroot make subversion python-support | grep ^ii |awk '{print $2}')

# Just in case...
rm -rf ${BASE_DIR} > /dev/null 2>&1 && echo "removing ${BASE_DIR}"
rm w3af_${VERSION}.orig.tar.gz > /dev/null 2>&1 && echo "removing w3af_${VERSION}.orig.tar.gz"

# copy trunk so we don't destroy our local copy
cp -Rp $DIR ${BASE_DIR} && echo ""

# copy the manpages
mkdir ${BASE_DIR}/manpage
cp -R ../manpage/w3af ${BASE_DIR}/manpage/w3af.1
cp -R ../manpage/w3af_console ${BASE_DIR}/manpage/w3af_console.1
cp -R ../manpage/w3af_gui ${BASE_DIR}/manpage/w3af_gui.1

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
#(rm ${BASE_DIR}/mozilla-extension/ -rf)  > /dev/null 2>&1 

# sanitize oHalberd (Remove the documentation and leave only the useful code part)
find ${BASE_DIR}/plugins/discovery/oHalberd/* -type d | grep -v "plugins/discovery/oHalberd/Halberd" | xargs rm -rf
rm ${BASE_DIR}/plugins/discovery/oHalberd/* > /dev/null 2>&1
# sanitize oHmap (Remove the documentation and leave only the useful code part)
find ${BASE_DIR}/plugins/discovery/oHmap/ | grep -v ".py" | xargs rm > /dev/null 2>&1


# Remove the debian offending stuff
# There is some legal issues with pygoogle http://bugs.debian.org/282313 and w3af works anyway without it.
rm -rf ${BASE_DIR}/extlib/pygoogle/
# pywordnet is not maintained any more (see http://bugs.debian.org/369087). Probably python-nltk http://bugs.debian.org/279422 is a better option
rm -rf ${BASE_DIR}/extlib/pywordnet/
# nikto's database is not free.  (see http://www.mail-archive.com/debian-legal@lists.debian.org/msg38622.html)
rm -rf ${BASE_DIR}/plugins/discovery/pykto*
rm -rf ${BASE_DIR}/scripts/script-pykto.w3af
rm -rf ${BASE_DIR}/scripts/script-pykto_mutate.w3af
rm -rf ${BASE_DIR}/scripts/script-updatePyktoDb.w3af
rm -rf ${BASE_DIR}/scripts/script-gtkOutput.w3af
# These tools have other options in debian and do not contribute much to w3af as package.
rm -rf ${BASE_DIR}/tools/

# And remove the things that are already inside debian as packages
# python-cluster 
rm -rf ${BASE_DIR}/extlib/cluster/
# python-socksipy 
rm -rf ${BASE_DIR}/extlib/socksipy/
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

#fixing permitions
find ${BASE_DIR} -type d -exec chmod 755 {} \;
find ${BASE_DIR} -type f -exec chmod 644 {} \;

echo "creating w3af_${VERSION}.orig.tar.gz"
tar zcf w3af_${VERSION}.orig.tar.gz ${BASE_DIR}

echo '~/debian'
cp -r trunk/debian ${BASE_DIR}/
(find ${BASE_DIR}/debian -name .svn | xargs rm -rf) > /dev/null 2>&1 && echo -n ".svn, "

echo 'setting changelog'
# TODO chequear la existencia de DEBEMAIL y DEBFULLNAME
DATE=$(date -R)
sed -i "s/\[w3af_DEBEMAIL\]/$DEBEMAIL/" ${BASE_DIR}/debian/changelog
sed -i "s/\[w3af_DEBFULLNAME\]/$DEBFULLNAME/" ${BASE_DIR}/debian/changelog
sed -i "s/\[w3af_VERSION\]/$VERSION/" ${BASE_DIR}/debian/changelog
sed -i "s/\[w3af_DATE\]/$DATE/" ${BASE_DIR}/debian/changelog

echo 'setting desktop'
sed -i "s/\[w3af_VERSION\]/$VERSION/" ${BASE_DIR}/debian/desktop

echo "The w3af directory inside ${BASE_DIR} contains all you need to create the .deb package."

#echo "Building the package..."
#cd ${BASE_DIR} 
#fakeroot ./debian/rules binary   > /dev/null 2>&1  && echo ' done.'
