#!/bin/sh
if [ -r /usr/share/w3af/w3af_console ] ; then 
   python /usr/share/w3af/w3af_console $@
fi
