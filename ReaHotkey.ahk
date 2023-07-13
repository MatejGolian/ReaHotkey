#Requires AutoHotkey v2.0

#Requires AutoHotkey v2.0
#MaxThreadsPerHotkey 1
#SingleInstance Force
#Warn
SendMode "Input"
SetTitleMatchMode "RegEx"
SetWorkingDir A_InitialWorkingDir
CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"

#Include Classes/AccessibilityOverlay.Class.ahk
#Include Classes/Plugin.Class.ahk
#Include Classes/Standalone.Class.ahk
#Include Includes/Functions.ahk

AppName := "ReaHotkey"
FoundPlugin := False
FoundStandalone := False
Plugin.Register("Engine", ["Plugin00007.*"], "FocusEnginePlugin")
Plugin.Register("Kontakt/Komplete Kontrol", ["NIVSTChildWindow00007.*", "Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1"], "", True)
PluginWinCriteria := "ahk_exe reaper.exe ahk_class #32770"
Standalone.Register("Engine", "Best Service Engine ahk_class Engine")
StandaloneWinCriteria := ""

A_IconTip := AppName
A_TrayMenu.Delete("&Pause Script")
A_TrayMenu.Rename("E&xit", "&Close")

AccessibilityOverlay.Speak(AppName . " ready")

#Include Includes/Overlays.ahk
#Include Includes/Plugin.ahk
#Include Includes/Standalone.ahk

SetTimer ManageHotkeys, 100
