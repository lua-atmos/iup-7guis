#!/bin/bash

f()
{
    ln -s /usr/lib64/lib$1.so /usr/local/lib/lib$1.so
}

f iupcd
f iupcontrols
f iupglcontrols
f iupgl
f iupimglib
f iupim
f iup_mglplot
f iup_plot
f iup_scintilla
f iup
f iuptuio
f iupweb

g()
{
    ln -s /usr/lib64/lib$154.so /usr/local/lib/lua/5.4/$1.so
}

g iuplua
g iupluacontrols
g iupluacd
g iupluagl
g iuplua_plot
g iuplua_mglplot
g iupluaim
g iupluaimglib
g iupluatuio
#g iupluascintilla
g iupluaglcontrols
g iupluaweb
g iupluascripterdlg
