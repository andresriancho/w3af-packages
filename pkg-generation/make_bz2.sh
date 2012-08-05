#!/bin/bash

if [ $# != 1 ]; then
    echo 'Usage: mkBz2.sh <tag-name>'
    exit
fi

set -x

# download the newly created tag
cd ../../tags/
svn up

# now we copy the tag to a temp directory
cd ../extras/pkg-generation/

# copy the tag so we don't destroy our local copy
cp -Rp ../../tags/$1/ ../../w3af

# change the SVN URL for the tag to the trunk so we properly update the user's installation
cd ../../w3af
svn switch https://w3af.svn.sourceforge.net/svnroot/w3af/trunk
cd -

# remove the compiled python modules
find -L ../../w3af -name *.pyc | xargs rm

# remove the backup files
find -L ../../w3af -name '*~' | xargs rm

# remove the svn stuff
#   AR:
#       Since we're going to be shipping an "Auto-Update feature" based on SVN in the near future,
#       I think that it's smart to keep the SVN metadata in the package. It won't hurt much in the
#       package size since the metadata holds the same information as the file and that should be
#       handled by tar.
#find -L ../../w3af -name .svn | xargs rm -rf

# remove some paths and files that are created during the run
rm ../../w3af/.urllib2cache/ -rf
rm ../../w3af/.tmp/ -rf
rm ../../w3af/output*.* -rf
rm ../../w3af/gprof2dot.py -rf
rm ../../w3af/w3af_crash.txt -rf

# clean previous builds that I made today
rm w3af-$1.tar
rm w3af-$1.tar.bz2

# Create the tar archive
tar -chpvf w3af-$1.tar ../../w3af

echo "Creating bz2 file."

bzip2 w3af-$1.tar

echo "File created!"

du -sh  w3af-$1.tar.bz2

# Cleanup
rm -rf ../../w3af

set +x

echo "You may upload the new package using SFTP following these instructions:"
echo "http://apps.sourceforge.net/trac/sourceforge/wiki/SFTP"
