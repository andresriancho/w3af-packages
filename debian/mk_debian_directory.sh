#!/bin/bash

# Just in case...
rm -rf w3af

# copy trunk so we don't destroy our local copy
cp -Rp ../../trunk w3af

# remove the compiled python modules
find -L w3af -name *.pyc | xargs rm

# remove the backup files
find -L w3af -name '*~' | xargs rm

# remove the svn stuff
find -L w3af -name .svn | xargs rm -rf

# remove some paths and files that are created during the run
rm w3af/.urllib2cache/ -rf
rm w3af/.tmp/ -rf
rm w3af/output-*.txt -rf
rm w3af/sessions/* -rf
rm w3af/w3af.e3* -rf

# This is not ready for distribution yet
rm w3af/mozilla-extension/ -rf

# Remove the debian offending stuff
rm -rf w3af/extlib/pygoogle/
rm -rf w3af/extlib/pywordnet/
rm -rf w3af/plugins/discovery/wordnet.py

# End!
echo 'The w3af directory inside "." contains all you need to create the .deb package.'

