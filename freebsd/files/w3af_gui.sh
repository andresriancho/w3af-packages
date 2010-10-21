#!/bin/sh
#
# $FreeBSD: ports/security/w3af/files/w3af_gui.sh,v 1.2 2010/10/21 07:29:56 jadawin Exp $
#

cd %%PATH%%
exec %%PYTHON_CMD%% -O w3af_gui.py
