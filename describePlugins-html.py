#!/usr/bin/env python

'''
describePlugins-html.py

Copyright 2007 Andres Riancho

This file is part of w3af, w3af.sourceforge.net .

w3af is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation version 2 of the License.

w3af is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with w3af; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

'''
import sys
import os
import cgi

parent_dir = os.path.abspath("..")
sys.path.append(parent_dir)
from core.controllers.w3afCore import wCore as w3afCore
os.chdir('..')

class htmlFile:
    def __init__( self, info ):
        self._stream = '''<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en"><head>
        <meta http-equiv="content-type" content="application/xhtml+xml; charset=ISO-8859-15">
        <meta name="author" content="Andres Riancho">
        <meta name="robots" content="index, follow">
        <META name="keywords" content="web application scanner, web appplication security, w3af, web framework, web hacking, web security scanner">
        <link rel="stylesheet" type="text/css" href="default.css" title="default">
        <meta name="description" content="w3af is a Web Application Attack and Audit Framework">
        <title>w3af - Plugins and descriptions</title>
        </head>'''
        self._stream += '''<body>
        <?php require_once("header.html");?>
        <?php include_once("analyticstracking.php"); ?>
        '''
        
        self._stream += '''
        <div id="body">
        <br/>
        <div align="center"><h3>w3af - Plugins</h3></div>
        <br/>
        <br/>
        '''
        self._stream += '''This is the list of plugins that are available in w3af, if you have any comments or feature requests, don't hesitate to
        send them to the w3af mailing list. A list of features provided by the framework is available <a href="features.php">here</a>.'''
        self._stream += self._generateHtmlIndex( info )
    
    def _generateHtmlIndex( self, info ):
        res = ''
        for pluginType in info.keys():
            res += '<br/><br/><b><a class="pluginType" href="#'+pluginType+'">'+pluginType+'</a></b><br/>\n'
            for pluginName in info[ pluginType ]:
                res += '&nbsp;&nbsp;&nbsp;&nbsp;<a class="pluginName" href="#'+pluginName+'">'+pluginName+'</a><br/>\n'
        return res
    
    def startPluginType( self, type ):
        self._stream += '<h1 class="pluginType" id="'+type+'">'+type+'</h1><br/>\n'
        
    def stopPluginType( self ):
        self._stream += '<br/><br/>\n\n'
        
    def addDescription( self, pluginName, description ):
        description = cgi.escape(description[1:])   # Remove the first \n
        description = description.replace('\t','&nbsp;&nbsp;&nbsp;&nbsp;')
        description = description.replace('    ','&nbsp;&nbsp;&nbsp;&nbsp;')
        description = description.replace('\n','<br/>')
        self._stream += '<h4 class="pluginName" id="'+pluginName+'">'+pluginName+'</h4>\n'
        self._stream += '&nbsp;&nbsp;&nbsp;&nbsp;<p class="description">'+description+'</p><br/>\n'
        self._stream += '<a class="topOfPage" href="#top" title="pagetop">top</a>'
        
    def getHtml( self ):
        # Close the div with id body, and the other ones..
        self._stream += '</div></body></html>\n'
        return self._stream
        
def createPHP( info ):
    '''
    Create html files in the html directory. Html files contain the description of all plugins.
    '''
    htf = htmlFile( info )
    for pluginType in info.keys():
        htf.startPluginType( pluginType )
        for pluginName in info[ pluginType ]:
            htf.addDescription( pluginName, info[pluginType][pluginName] )
        htf.stopPluginType()
    
    try:
        os.mkdir('extras/html')
    except:
        pass
        
    outfile = file( 'extras/html/pluginDesc.php', 'w' )
    outfile.write( htf.getHtml() )
    outfile.close()
    
def getInformation():
    '''
    Get the needed information from the core and the plugins.
    '''
    info = {}
    for pluginType in w3afCore.getPluginTypes():
        info[pluginType] = {}
        for pluginName in w3afCore.getPluginList( pluginType ):
            configurableObject = w3afCore.getPluginInstance( pluginName, pluginType )
            info[pluginType][pluginName] = configurableObject.getLongDesc()
    return info
    
if __name__ == '__main__':
    information = getInformation()
    createPHP( information )
