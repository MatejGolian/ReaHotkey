#requires AutoHotkey v2.0

#maxThreadsPerHotkey 1
#singleInstance Force
#warn
sendMode "input"
setTitleMatchMode "regEx"
setWorkingDir A_InitialWorkingDir
coordMode "mouse", "window"
coordMode "pixel", "window"

appName := "GetWinClass"
reaperFX_winCriteria := "ahk_exe reaper.exe ahk_class #32770"

A_IconTip := appName
A_TrayMenu.delete("&Open")
A_TrayMenu.delete("&Help")
A_TrayMenu.delete("&Window Spy")
A_TrayMenu.delete("&Reload Script")
A_TrayMenu.delete("&Edit Script")
A_TrayMenu.delete("&Pause Script")
A_TrayMenu.rename("E&xit", "&Close")

msgBox "Press Ctrl+G to retrieve the class of the active window and copy it to clipboard.", appName

^G:: {
    A_Clipboard := winGetClass("A")
}
