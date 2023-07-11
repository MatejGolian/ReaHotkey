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

AppName := "Shreddage Guitar Selector"
ReaperFX_WinCriteria := "ahk_Exe Reaper.Exe Ahk_Class #32770"
ReaperFX_ControlClasses := Array("NIVSTChildWindow00007.*", "Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1")

A_IconTip := AppName
A_TrayMenu.Delete("&Pause Script")
A_TrayMenu.Rename("E&xit", "&Close")

AccessibilityOverlay.Speak(AppName . " ready")

PluginOverlay := AccessibilityOverlay()
PluginOverlay.AddHotspotButton("Guitar Number 1", 1052, 524)
PluginOverlay.AddHotspotButton("Guitar Number 2", 1076, 524,)
PluginOverlay.AddHotspotButton("Guitar Number 3", 1100, 524)
PluginOverlay.AddHotspotButton("Guitar Number 4", 1124, 524)

#Include Includes/ReaperFX.ahk
