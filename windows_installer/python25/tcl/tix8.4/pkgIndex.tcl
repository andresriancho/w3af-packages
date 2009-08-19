package ifneeded Tix 8.4 [list load "[file join [file dirname [file dirname $dir]] DLLs tix84.dll]" Tix]
package ifneeded wm_default 1.0 [list source [file join $dir pref WmDefault.tcl]]
