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

appName := "Nucleus Mix Selector"
reaperFX_winCriteria := "ahk_exe reaper.exe ahk_class #32770"
reaperFX_controlClasses := Array("NIVSTChildWindow00007.*", "Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1")

A_IconTip := appName
A_TrayMenu.rename("E&xit", "&Close")

accessibilityOverlay.speak(appName . " ready")

pluginOverlay := accessibilityOverlay()
pluginOverlay.addHotspotButton("Classic Mix", 690, 402)
pluginOverlay.addHotspotButton("Modern Mix", 690, 432)

#include Includes/reaperFX.ahk
