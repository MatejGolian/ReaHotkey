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

appName := "Areia/Jaeger Mix Selector"
reaperFX_winCriteria := "ahk_exe reaper.exe ahk_class #32770"
reaperFX_controlClasses := array("NIVSTChildWindow00007.*", "Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1")

A_IconTip := appName
A_TrayMenu.delete("&Pause Script")
A_TrayMenu.rename("E&xit", "&Close")

accessibilityOverlay.speak(appName . " ready")

pluginOverlay := accessibilityOverlay()
pluginOverlay.addHotspotButton("Classic Mix", 678, 448)
pluginOverlay.addHotspotButton("Modern Mix", 775, 448)

#include Includes/reaperFX.ahk
