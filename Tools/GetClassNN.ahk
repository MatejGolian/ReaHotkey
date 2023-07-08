#requires AutoHotkey v2.0

#maxThreadsPerHotkey 1
#singleInstance Force
#warn
sendMode "input"
setTitleMatchMode "regEx"
setWorkingDir A_InitialWorkingDir
coordMode "mouse", "window"
coordMode "pixel", "window"

appName := "GetClassNN"
reaperFX_winCriteria := "ahk_exe reaper.exe ahk_class #32770"

A_IconTip := appName
A_TrayMenu.delete("&Pause Script")
A_TrayMenu.rename("E&xit", "&Close")

msgBox "Press Ctrl+G to retrieve the class of the currently focused control in the REAPER FX window and copy it to clipboard.", appName

#hotIf winActive(reaperFX_winCriteria)

^G:: {
    A_Clipboard := controlGetClassNN(controlGetFocus(reaperFX_winCriteria))
}
