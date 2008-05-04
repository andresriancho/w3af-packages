#!/bin/bash

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
rm ../../w3af/output-*.txt -rf
rm ../../w3af/sessions/* -rf
rm ../../w3af/w3af.e3* -rf
rm ../../w3af/extras/ -rf

# Create the tar archive
tar -chpvf w3af-`date +%d%b%Y`.tar ../../w3af

echo "Creating bz2 file."

bzip2 w3af-`date +%d%b%Y`.tar

echo "File created!"

du -sh  w3af-`date +%d%b%Y`.tar.bz2

# Cleanup
rm -rf ../../w3af

