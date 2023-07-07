#requires AutoHotkey v2.0

#maxThreadsPerHotkey 1
#singleInstance Force
#warn
sendMode "input"
setTitleMatchMode "regEx"
setWorkingDir A_InitialWorkingDir
coordMode "mouse", "window"
coordMode "pixel", "window"

#include Includes/accessibilityOverlay.ahk

appName := "Shreddage Guitar Selector"
reaperFX_winCriteria := "ahk_exe reaper.exe ahk_class #32770"
reaperFX_controlClasses := array("NIVSTChildWindow00007.*", "Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1")

A_IconTip := appName
A_TrayMenu.delete("&Pause Script")
A_TrayMenu.rename("E&xit", "&Close")

accessibilityOverlay.speak(appName . " ready")

pluginOverlay := accessibilityOverlay()
pluginOverlay.addHotspotButton("Guitar Number 1", 1052, 524)
pluginOverlay.addHotspotButton("Guitar Number 2", 1076, 524,)
pluginOverlay.addHotspotButton("Guitar Number 3", 1100, 524)
pluginOverlay.addHotspotButton("Guitar Number 4", 1124, 524)

#include Includes/reaperFX.ahk
