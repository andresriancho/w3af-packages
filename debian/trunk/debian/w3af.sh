#!/bin/sh
if [ ! -z "$DISPLAY" -a -r /usr/share/w3af/w3af_gui ] ; then 
   python /usr/share/w3af/w3af_gui $@
else
   python /usr/share/w3af/w3af_console $@
fi
