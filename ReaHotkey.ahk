#Requires AutoHotkey v2.0

#MaxThreadsPerHotkey 1
#SingleInstance Force
#Warn LocalSameAsGlobal, Off
SendMode "Input"
SetTitleMatchMode "RegEx"
SetWorkingDir A_InitialWorkingDir
CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"

#Include Includes/AccessibilityOverlay.Class.ahk
#Include Includes/Plugin.Class.ahk
#Include Includes/Standalone.Class.ahk
#Include Includes/General.Functions.ahk
#Include Includes/Overlay.Functions.ahk

AppName := "ReaHotkey"
FoundPlugin := False
FoundStandalone := False
PluginWinCriteria := "ahk_exe reaper.exe ahk_class #32770"
StandaloneWinCriteria := ""

A_IconTip := AppName
A_TrayMenu.Delete("&Pause Script")
A_TrayMenu.Rename("E&xit", "&Close")

AccessibilityOverlay.Speak(AppName . " ready")

Plugin.Register("Engine", "Plugin[0-9A-F]{17}", FocusEnginePlugin)
Plugin.Register("Kontakt/Komplete Kontrol", ["NIVSTChildWindow00007.*", "Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1"],, True)
Standalone.Register("Engine", "Best Service Engine ahk_class Engine ahk_exe Engine 2.exe", InitEngineStandalone)

ImportOverlays()

#Include Includes/Plugin.Context.ahk
#Include Includes/Standalone.Context.ahk

SetTimer UpdateState, 100
SetTimer ManageHotkeys, 100
SetTimer ManageTimers, 100
