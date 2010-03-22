#!/bin/sh
if [ ! -z "$DISPLAY" -a -r /usr/share/w3af/w3af_gui ] ; then 
   /usr/bin/python2.5 /usr/share/w3af/w3af_gui $@
else
   /usr/bin/python2.5 /usr/share/w3af/w3af_console $@
fi
