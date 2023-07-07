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
A_TrayMenu.delete("&Open")
A_TrayMenu.delete("&Help")
A_TrayMenu.delete("&Window Spy")
A_TrayMenu.delete("&Reload Script")
A_TrayMenu.delete("&Edit Script")
A_TrayMenu.delete("&Pause Script")
A_TrayMenu.rename("E&xit", "&Close")

msgBox "Press Ctrl+G to retrieve the window class of the currently selected FX in REAPER and copy it to clipboard.", appName

#hotIf winActive(reaperFX_winCriteria)

^G:: {
    A_Clipboard := controlGetClassNN(controlGetFocus(reaperFX_winCriteria))
}
