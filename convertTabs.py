import os
from os.path import join
from os import walk, system

for root, dirs, files in walk('.'):
	filenames = [join(root, name) for name in files if '.svn' not in root and name.endswith('.py') and name != 'convertTabs.py' ]
	for filename in filenames:
		system('python /usr/share/doc/python2.5/examples/Tools/scripts/untabify.py -t 4 ' + filename )

