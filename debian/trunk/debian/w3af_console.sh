#!/bin/sh
if [ -r /usr/share/w3af/w3af_console ] ; then 
   /usr/bin/python2.5 /usr/share/w3af/w3af_console $@
fi
