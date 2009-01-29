#~ Portable Python - run python without installation
#~ Copyright (C) 2006 Perica Zivkovic
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~      This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License 
#~      as published by the Free Software Foundation; 
#~      This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
#~      without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
#~      See the GNU General Public License for more details.
#~      You should have received a copy of the GNU General Public License along with this program; 
#~      if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
from Tkinter import *
from ToolTip import *
import tkFileDialog
import tkSimpleDialog
import tkMessageBox
import os
import sys
import string
from TkTreectrl import *
import ctypes
import time

# 
# Define images
#
add_gif='''\
    R0lGODlhEAAQANUAADV2VDh6Vzh5Vzt+Wjx+WkCFXkSLYkWMY0WLYkWLY0WMYkqTZ0qTaE+abFCa
    bFShcVWhcVShcFindVWicVyseV+we12seY20U420VJa5VZa5VqDAWKHAWKzHWqzHW63HWq3GWq3H
    W8XWYMbWYMXVYMbVYMXVYdDbY9riZdrhZeDlZv///wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAEAACsALAAAAAAQABAAAAZbwJVw
    SCwaj0hhZVlJDisqVdO5oqRQFupKcpUgJxHI40Q+Pc4PokMkMpHapRG7QWSEQqAOKOT5+BdEBgkK
    ChscGxsKCAcHSAUZGgVaBBgXA1oBlQJaAJ0AWqCgQQA7
    '''
delete_gif='''\
    R0lGODlhEAAQANUAAMczNfRxdPRzdPNydPNzddgqL+AsNN8sM8cpMOY2PuU2PsUgK+UwOfJVYPRj
    a/NjavNja/Nka8UYJ8YZKMUZJ8YgLPJUYMUTJfE/UvA/UfJIWPFIWNRldN+cqMpdSc5uXspXRspY
    RslYRtWIfMlQQ9ymoMlHPslHP8hHP8c9OeBhW/WBfcc9OuNST/WAfvSAfuPExP///wAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAEAADEALAAAAAAQABAAAAZ8wJhw
    SCwaj0eYZ1QceWBEWKgVYgpHohYIKiyRXCvSp/QhvcIl4ghFEKhMqkHgZCVyWBHIw/FIcZAACg0N
    FgkASDEIDBsaGgwISBwVGJSUC39FHBOUBRIFGBkUmEIdF6AXHB0cphkXHUMwFwaoQ6sHF1xCsaNC
    q7mIwMExQQA7
    '''
run_gif='''\
    R0lGODlhEAAQANUAACCAQSaAQSaIQUGRV16abzqITzOISGatdy2IQUiRV0iaVzqRSEGRT2atbzqI
    QTN3OkGISEiRT0+aV1ekXi2AMzOIOkGaSEiaTzqIOkGRQVekV0iASGakZnetd63LrbrSutXg1V6a
    V4i3gG+kXoCtb4i3d5rBiIi3b5G3d5G3b6TBiIDMJsLpeP///////wAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAEAAC4ALAAAAAAQABAAAAaYQJdw
    SCwWQYdCIFA4gIyug2G1MqlEnGbxkCitWqtUCoVKHIYgA+n0aYFP8JPhGZWMRm336n4/uwwhgXl6
    gR0GQgYbih5ujSwbHQFCAA+VjI0flQQAQgEUn5ctHp8QE5JRDBERlx6qFxIDfiAIEhmMHg4OGRcT
    CHRRCxMeHhUYFhoTC35DBwgKEw0NEwoIy0RIAksCTlDdRUEAOw==
    '''
new_gif='''\
    R0lGODlhEAAQANUAAPP1+/j5/IORsYORsIeTroOSsYKRsIOSsO7y+vL1+/n6/Pj5+4aavoyfwoaU
    rouWq/D0+5Omxpqsy6Kzz6i406y81d7o+N3n99/o9+Ts+efu+e3y+vP2+9zn99/p+N7o9+Hq+Orw
    +fb4+5CaqObu+fD1+/L2+5adpPX4+/f5+5WdpJuhoaGknKeomKeoma2rlbKvkrKukru0i7exjrex
    j7+2iODIj9SyaNSyadq9fNWyaf///wAAAAAAAAAAAAAAACH5BAEAADsALAAAAAAQABAAAAZ/wJ1w
    SCwSa8gk0iisKZ5QXI0pSwUW1kBONy3SUJJIgyGy5W6zYizBMXEAnDgHVnyVKpRJeAx5FVsbGwiB
    hBsuRSwheHpiDCEsRSskGpSVkytFKhmLewwZJ0UjIKOkpCNFDx6MYxgfFg9FDh0dF7S0tQRFAgUH
    Bry9BwIDTMRDQQA7
    '''
open_gif='''\
    R0lGODlhEAAQAMQAAPjomPjwyPjosOjQiPDYkPjgmPjgoPjYiPjQeODAePjYkPjQgNiwcLyFMsOL
    NrR/MqVsJK1yK7x/MsOFNq1sJJ5mJ61yL55fHZ5fII9SGf///////wAAAAAAAAAAAAAAACH5BAEA
    ABsALAAAAAAQABAAAAVV4CaOZGmeaGo6rKNulCZrVDoBADEkzOT7pEZgSCw2SBKBcsnEkB6GqMFC
    rVo3EYXWUuh6uwPLBnI4WMpodFh0QVgW8Dh8LcpYEPg8nj6q+P+AL4KDIQA7
    '''
py_gif='''\
    R0lGODlhEAAQAPcAAAAAAEVjfUZkfUVkfj9xmT5znj50oD11oj11ozt6rTx4qTx5qz5+sUNnhUNo
    h0dphUJpiUFrjkFtkkBulEVvkUt4nUl+qT2AtkeCskWGu3GVs//DMP/HNP/FOP/IM//KNf/MN//L
    P//QPf/RPv/SQP/UQv/XRv/SSP/YR//bS//dTf/bU//fU//gUf/jVv/lWP/nWv/pX//rYP/sYf/t
    Y//idp2dnZ+fn4mcrKCgoKKioqOjo6SkpKWlpaampqioqKqqqqurq6ysrK2tra6urq+vr7Ozs7a2
    tre3t7m5ubu7u729vb6+vr+/v6e6yqS80KLC3rDB0KHE4P/gmf/im//0m//sqP/xrv/yt8DAwMHB
    wcPDw8TExMXFxcfHx8jIyMnJyczMzM3Nzc7Ozs/Pz9DQ0NHR0dzc3N3d3d7e3t/f39Pg6v/00uHh
    4eLi4uPj4+Tk5OXl5ebm5ufn5+jo6Onp6ezs7O3t7e7u7urv8//76/Dw8PHx8fLy8vPz8/X19fb2
    9vf39/j4+Pn5+fr6+vv7+/z8/P39/f7+/v///wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAEAAP8ALAAAAAAQABAA
    AAj/AJEkUbKkiZYtXb6A8cLln8N/SsbAASRIECFChr4MCtPkIZM0gQalmYOnDaJDiRDZeaiFjBxD
    b/BYhIIBQQUniRx2USMIUaCTiRisIRDhQc5/YMzMOYTmEKJEUKM0CAA1kRc1gQgBknJBQQEJDgQI
    SMTCypYycQQlyrDAwAQIAwTg0IPiRJY0gP4kSnBAQ56qemqM8LBEYh9EFgjkqUJDhosUJD50SIIG
    0B5CTygkojHjhYoSIDZMOSLGzZ07g57OgIGlKlQjZ/zAmVOHDqIYLUyw4XC0iBYiQH4YEQPoygoR
    IagcFRIEyL8eO3IMiYOyEJ+HQR4+tHFDB48ePh4GAQQAOw==
    '''    
console_gif='''\
    R0lGODlhEAAQAOYAAPP1+/f4+zpOgUFWiENYi0pgklBmmFZtnmB3qF11pmZ/r1Rkg1dnhvb4/Ftr
    iV9vjGR0kOHp+OHp91priGl6lWl5lG5+mHODnOXs+Onv+e3y+m5/mHeHn3eHnuHq+OHq9+Ts+Pb4
    +ytcnCtalytYkytXkEZzrVp/r3KDm3aHn3eIn3aHnuDq9+Xt+O7z+vP2+ilvxCluwilsvilruipq
    uilotSpotSlmsCpmsSpjrCpkqyphpithpipfoStfoStcmypalypblytblypYkypZkypXkCtYkCtX
    j3aIn/L2++3z+vb5/Pb5+8/t+////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5
    BAEAAE4ALAAAAAAQABAAAAejgE6Cg4SFgycwiYqLMCeDMQuRkpMLMYMyDE2am5sMMoMzE01MIQEh
    Sw0hDQ40gzYPTQoJBgQCL0kADzWDNxBNLi5KwMAaEDiDORSxCggHBQMCGRU6gzsbTRggIBjZGC0W
    PIM9KE0sER8eERIRHhc+gz8pKR0pHCopK0jyIoMmQkJB/gUBImQEQBOGnJggMYQIwoQmjByReKRE
    kRIlHibcyHFjIAA7
    '''
quickrun_gif='''\
    R0lGODlhEAAQAOYAAEOTXkiUXzKESUOUW0mRXbPSvC2ERD+VVoe9laXPsE2XX3S0g4C4jqPOrb7a
    xcbcy8bay9fk2jyTTkOXVUGSUk2WXWCncFaSY3Kwf4G4jXOxf0GNTk6YWlKYXjyNSEqTVFGaW12k
    aNnm2y98OE2XVlukYyp9MjWEPUWNTFSgXMDVwi9/NT6PRESQSTp3PrbSuDeMOzZ2OkiYTDqIPUST
    RmykbbDOsbjTua3Lra3KrbfQt/X49bjSt12dWFSPT1qSVHS2bHGmZ0qIO2yjX2+kYGyjWcvcxXKm
    XmWjSIa0boe0bpa6gZK5eLrYpoG0WJ3VYIXOLp7VX5i/ba7ecq7cdvv/9vn+8P7/+Pj46P797/jw
    sPjomPDYgPjgiPDgqPjQYPjYePjYgLCDGbB8FKFuD5poD6l1FP///////wAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5
    BAEAAGgALAAAAAAQABAAAAergGhoBUA0BBUZDoKLiwgkUFNSS0EdCYyCEB9KTVZRTkxJHBGXFj1H
    KmdVT0hEQxqXGz8+OmdnV1RFNQqXAi4xObVnRkIXAJcGKyY4tTcnIyADlxgeLTZnLygsDxQMlyIS
    Mjw3MzAPYg/mYowNEyElKeZZYjtiWOqLDwsHAeZYWmL1vNy7hEZMFy0IEXIZQ1CQGTBbIm4BY6ah
    IDIYw3whY5FRmS9lOnoMKSgQADs=
    '''
    
py_ico = sys.exec_prefix + os.sep + "DLLs\\py.ico"

class NewDialog(tkSimpleDialog.Dialog):
    def __init__(self, parent, oldPath):
        Toplevel.__init__(self, parent)
        self.lastPath = oldPath
        self.transient(parent)
        self.parent = parent
        self.result = None
        self.valid = False
        body = Frame(self)
        self.initial_focus = self.body(body)
        body.pack(padx=5, pady=5)
        self.bitmapOpen = PhotoImage(data=open_gif)
        
        self.script = None
        self.arguments = None
        self.spawn = IntVar()
        self.spawn.set(1)

        Label(body, text="Script location").grid(row=0)
        Label(body, text="Script arguments").grid(row=1)
        Checkbutton(body, text="Run in separate process...", variable=self.spawn).grid(row=2, column=1)

        self.scriptLocation = Entry(body, width=30)
        self.scriptLocation.grid(row=0, column=1)
        self.scriptArguments = Entry(body, width=30)
        self.scriptArguments.grid(row=1, column=1)
        Button(body, text="Select script", image=self.bitmapOpen, command=self.selectFolderHandler).grid(row=0, column=2)

        # selected folder
        self.buttonbox()
        if not self.initial_focus:
            self.initial_focus = self
        self.geometry("+%d+%d" % (parent.winfo_rootx()+50,  parent.winfo_rooty()+50))
        self.initial_focus.focus_set()
        self.wait_window(self)

    def body(self, master):
        self.iconbitmap(py_ico)

    def selectFolderHandler(self):
        if(not(os.path.exists(self.lastPath))):
            self.lastPath = "."
            
        fileName = tkFileDialog.askopenfilename(filetypes=[("Python Files", ".py"), ("Python Files", ".pyw")], initialdir=self.lastPath, title='Please select a python script...')
        if file != None:
            self.scriptLocation.delete(0, END)
            self.scriptLocation.insert(END, fileName)
            self.scriptLocation.xview(END)

    def validate(self):
        if(os.path.exists(self.scriptLocation.get()) == False):
            tkMessageBox.showerror("Error", "Please enter valid script location...")
            return 0
        return 1
        
    def apply(self):
        self.script = self.scriptLocation.get()
        self.arguments = self.scriptArguments.get()
        self.valid = True

class App:
    # init
    def __init__(self, master):
        self.scriptColl = []
        self.master = master
        self.py = sys.exec_prefix + os.sep + "python.exe"
        self.pyw = sys.executable
        self.lastPath = "."

        self.bitmapAdd = PhotoImage(data=add_gif)
        self.bitmapDelete = PhotoImage(data=delete_gif)
        self.bitmapRun = PhotoImage(data=run_gif)
        self.bitmapNew = PhotoImage(data=new_gif)
        self.bitmapOpen = PhotoImage(data=open_gif)
        self.bitmapPy = PhotoImage(data=py_gif)
        self.bitmapConsole = PhotoImage(data=console_gif)
        self.bitmapQuickrun = PhotoImage(data=quickrun_gif)

        # create a toplevel menu
        self.menubar = Menu(master)
        # filemenu
        filemenu = Menu(self.menubar, tearoff=0)
        filemenu.add_command(label="Exit", command=self.quit)
        # helpmenu
        helpmenu = Menu(self.menubar, tearoff=0)
        helpmenu.add_command(label="Content", command=self.pythonHelp)
        helpmenu.add_command(label="About", command=self.about)
        # create entries in the main menu
        self.menubar.add_cascade(label="File", menu=filemenu)
        self.menubar.add_cascade(label="Help", menu=helpmenu)
        
        # toolbar
        self.toolbar = Frame(master, width=400, height=20)
        self.toolbar.pack(fill=X, padx=2)
        # btn add component
        btnAddScript = Button(self.toolbar, text="Add script", command=self.addScript)
        btnAddScript.configure(overrelief=RAISED, relief=GROOVE, image=self.bitmapAdd)
        btnAddScript.pack(side=LEFT)
        ToolTip(btnAddScript, follow_mouse=1, text=btnAddScript.cget("text"), delay=500)
        # btn delete component
        btnDeleteScript = Button(self.toolbar, text="Delete script", command=self.deleteScript)
        btnDeleteScript.configure(overrelief=RAISED, relief=GROOVE, image=self.bitmapDelete)
        btnDeleteScript.pack(side=LEFT)
        ToolTip(btnDeleteScript, follow_mouse=1, text=btnDeleteScript.cget("text"), delay=500)
        # separator
        separator = Frame(self.toolbar, width=10, height=10)
        separator.pack(side=LEFT)
        # btn run selected script
        btnRunSelected = Button(self.toolbar, text="Run selected script...", command=self.runSelected)
        btnRunSelected.configure(overrelief=RAISED, relief=GROOVE, image=self.bitmapRun)
        btnRunSelected.pack(side=LEFT)
        ToolTip(btnRunSelected, follow_mouse=1, text=btnRunSelected.cget("text"), delay=500)
        # btn quick run
        btnQuickRun = Button(self.toolbar, text="Quick run...", command=self.quickRun)
        btnQuickRun.configure(overrelief=RAISED, relief=GROOVE, image=self.bitmapQuickrun)
        btnQuickRun.pack(side=LEFT)
        ToolTip(btnQuickRun, follow_mouse=1, text=btnQuickRun.cget("text"), delay=500)
        
        # scripts multibox
        self.scriptList = ScrolledMultiListbox(self.master, relief=GROOVE, scrollmode='auto')
        self.scriptList.pack(fill=BOTH, expand=1)
        self.scriptList.listbox.config(columns=('Script', 'Arguments'), expandcolumns=(0,), selectmode='single')
        # add icon to first row
        image = self.scriptList.listbox.element_create(type='image', image=self.bitmapPy)
        icon_style = self.scriptList.listbox.style_create()
        self.scriptList.listbox.style_elements(icon_style, self.scriptList.listbox.element('select'), image, self.scriptList.listbox.element('text'))
        self.scriptList.listbox.style_layout(icon_style, image, padx=3, pady=2)
        self.scriptList.listbox.style_layout(icon_style, self.scriptList.listbox.element('text'), padx=4, iexpand='e', expand='ns')
        self.scriptList.listbox.style_layout(icon_style, self.scriptList.listbox.element('select'), union=(self.scriptList.listbox.element('text'), image), ipady=1, iexpand='nsew')
        self.scriptList.listbox.style(0, icon_style)
        
        # statusbar
        self.statusbar = Frame(self.master)
        self.statusbar.pack(side=BOTTOM, fill=X)
        Label(self.statusbar, text="Running on Python " + sys.version[0:3]).pack(side=TOP, anchor=W)
        
    def addScript(self):
        result = NewDialog(self.master, self.lastPath)
        
        if(result.valid == True):
            script = "..." + result.script[-25:]
            self.scriptList.listbox.insert(END, script, result.arguments)
            self.scriptColl.append([script, result.script, result.arguments, result.spawn])
            self.lastPath = os.path.split(result.script)[0]
    
    def deleteScript(self):
        selection = self.scriptList.listbox.selection_get()
        
        if selection != None:
            selectedIndex = self.scriptList.listbox.curselection()[0]
            print selectedIndex
            self.scriptColl.pop(selectedIndex)
            self.scriptList.listbox.delete(selectedIndex)
            print self.scriptColl

    def runSelected(self):
        selection = self.scriptList.listbox.selection_get()
        
        if selection != None:
            selectedIndex = self.scriptList.listbox.curselection()[0]          
            script = self.scriptColl[selectedIndex][1]
            arguments = self.scriptColl[selectedIndex][2]
            spawn = self.scriptColl[selectedIndex][3]
            self.executeWithArguments(script, arguments, spawn)
            
    def quickRun(self):
        result = NewDialog(self.master, self.lastPath)
        
        if(result.valid == True):
            self.executeWithArguments(result.script, result.arguments, result.spawn)
            self.lastPath = os.path.split(result.script)[0]
            
    def executeWithArguments(self, script, arguments, spawn):
        script = "\"" + script + "\""
        if spawn.get() == 0:
            pyExe = self.pyw
            wait = os.P_WAIT
        else:
            pyExe = self.py
            wait = os.P_NOWAIT
        
        os.spawnv(wait, pyExe, ('start ' + script, arguments))
            
    def pythonHelp(self):
        prefix = sys.exec_prefix
        helpfile = prefix + os.sep + "Doc" + os.sep + "Python25.chm"
        try:
            os.startfile(helpfile)
        except:
            tkMessageBox.showerror("Error", "Error: " + helpfile + " not found...")

    def about(self):
        tkMessageBox.showinfo("Portable python", "Portable python v1.0 beta \n\nCreated by Perica Zivkovic\nhttp://www.portablepython.com")
    
    def quit(self):
        self.master.destroy()

if __name__ == "__main__":        
    root = Tk()
    app = App(root)
    root.config(menu=app.menubar)
    root.title("Portable python")
    root.minsize(400, 290)
    #root.maxsize(400, 290)
    root.iconbitmap(py_ico)
    root.mainloop()