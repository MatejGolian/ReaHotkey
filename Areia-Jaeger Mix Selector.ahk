#Requires AutoHotkey v2.0

#MaxThreadsPerHotkey 1
#SingleInstance Force
#Warn
SendMode "Input"
SetTitleMatchMode "RegEx"
SetWorkingDir A_InitialWorkingDir
CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"

#Include Includes/AccessibilityOverlay.ahk

AppName := "Areia/Jaeger Mix Selector"
ReaperFX_WinCriteria := "ahk_exe reaper.exe ahk_class #32770"
ReaperFX_ControlClasses := Array("NIVSTChildWindow00007.*", "Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1")

A_IconTip := AppName
A_TrayMenu.Delete("&Pause Script")
A_TrayMenu.Rename("E&xit", "&Close")

AccessibilityOverlay.Speak(AppName . " ready")

PluginOverlay := AccessibilityOverlay()
PluginOverlay.AddHotspotButton("Classic Mix", 678, 448)
PluginOverlay.AddHotspotButton("Modern Mix", 775, 448)

#Include Includes/ReaperFX.ahk
