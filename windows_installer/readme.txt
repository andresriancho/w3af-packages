Compiling w3af installer:
-------------------------

Requirements:
-------------

1) NSIS
	url: http://nsis.sourceforge.net

2) Python 2.6.6
	url: http://www.python.org/download/releases/2.6.6/


Build Notes:
------------

	* The following directories must be present at the root directory in order to make the installer work:
		\Graphviz2.24 # Graphviz version may be different
		\GTK2-Runtime # At the moment the writing we are using version 2.22
		\Python26 # py version may be different
		..\w3af # A fresh w3af version downloaded from SVN server (must include .svn directories along the dir. structure)
		\image # contains the images that will be embedded in the installer
		\AddToPath.nsh # NSIS dependency script

	* Shellink plugin must be installed: Decompress \nsis-plugins\Shelllink.zip and copy Shellink.dll to Plugins folder in the NSIS installation.

	* Now just simply right click on the w3af-setup.nsi and select "Compile NSIS Script". Wait a few minutes and you'll see the output file look like this: "w3af 1.0 rc6 setup.exe"


Preparing dependency directories (Needed *only* when you want to upgrade at least one the involved dependencies):
-----------------------------------------------------------------------------------------------------------------

	* Graphviz:
		** After installing Graphviz on your machine run the script "dev-portable\copy_graphiz.bat". This will basically copy Graphviz from "Program Files" to the working directory.
			Feel free to edit the paths in it.

	* GTK2-Runtime:
		** First you should install all the inside prerequisite\py26\gtk\*.exe files (start with gtk2-runtime-xxx-ash.exe)
		** Then decompress the zip files and put the contents inside the created GTK2-Runtime folder.
		** Copy the content of prerequisite\py26\webkit\dlls\*.dll to GTK2-Runtime\bin folder.
		** Be sure to include "gtk2_prefs.exe" also in GTK2-Runtime\bin as well as the themes folder in GTK2-Runtime\share.
		
	* Python version (2.6.6 when this was written):
	    ** Install python on your machine.
		** Go through each folder inside prerequisite\py26 and execute the python dependencies installers. First read the README.txt if exists. Sometimes the dependency will be installed
			using python's easy_install or maybe you'll need only to copy some files.
		** Finally, run "dev-portable\copy_python.bat" (Again, feel free to modify the paths at your convinience)
		
	
	