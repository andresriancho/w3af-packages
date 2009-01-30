#!/bin/bash

set -x

# copy trunk so we don't destroy our local copy
cp -Rp ../../trunk ../../w3af

# remove the compiled python modules
find -L ../../w3af -name *.pyc | xargs rm

# remove the backup files
find -L ../../w3af -name '*~' | xargs rm

# remove the svn stuff
find -L ../../w3af -name .svn | xargs rm -rf

# remove some paths and files that are created during the run
rm ../../w3af/.urllib2cache/ -rf
rm ../../w3af/.tmp/ -rf
rm ../../w3af/output*.* -rf
rm ../../w3af/gprof2dot.py -rf
rm ../../w3af/w3af.e3* -rf
rm ../../w3af/w3af.e4* -rf
rm ../../w3af/w3af_crash.txt -rf

# remove the things that are under development
rm ../../mozilla-extension/ -rf

# Remove plugins under development
rm ../../w3af/plugins/discovery/_web20Spider.py -rf
rm ../../w3af/plugins/discovery/_mailer.py -rf


# Create the tar archive
tar -chpvf w3af-`date +%d%b%Y`.tar ../../w3af

echo "Creating bz2 file."

bzip2 w3af-`date +%d%b%Y`.tar

echo "File created!"

du -sh  w3af-`date +%d%b%Y`.tar.bz2

# Cleanup
rm -rf ../../w3af

