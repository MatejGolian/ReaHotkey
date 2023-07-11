#Requires AutoHotkey V2.0

#MaxThreadsPerHotkey 1
#SingleInstance Force
#Warn
SendMode "Input"
SetTitleMatchMode "RegEx"
SetWorkingDir A_InitialWorkingDir
CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"

#Include Includes/accessibilityOverlay.Ahk

AppName := "Nucleus Mix Selector"
ReaperFX_WinCriteria := "ahk_Exe Reaper.Exe Ahk_Class #32770"
ReaperFX_ControlClasses := Array("NIVSTChildWindow00007.*", "Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1")

A_IconTip := AppName
A_TrayMenu.Delete("&Pause Script")
A_TrayMenu.Rename("E&xit", "&Close")

AccessibilityOverlay.Speak(AppName . " ready")

PluginOverlay := AccessibilityOverlay()
PluginOverlay.AddHotspotButton("Classic Mix", 690, 402)
PluginOverlay.AddHotspotButton("Modern Mix", 690, 432)

#Include Includes/reaperFX.Ahk
