#Requires AutoHotkey v2.0

#MaxThreadsPerHotkey 1
#SingleInstance Force
#Warn All
SendMode "Input"
SetTitleMatchMode "RegEx"
SetWorkingDir A_InitialWorkingDir
CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"

#Include Includes/Overlay.Definitions.ahk
#Include Includes/Overlay.Functions.ahk

#Include <AccessibilityOverlay>
#Include <JXON>
#Include <OCR>
#Include <Plugin>
#Include <ReaHotkey>
#Include <Standalone>

A_IconTip := "ReaHotkey"
A_TrayMenu.Delete
A_TrayMenu.Add("&Pause", ReaHotkey.TogglePause)
A_TrayMenu.Add("&Close", ReaHotkey.Close)

AccessibilityOverlay.Speak("ReaHotkey ready")

Plugin.Register("Dubler 2", "JUCE_18a5c54cc971", , , False)
Plugin.Register("Engine", "^Plugin[0-9A-F]{17}")
Plugin.Register("Kontakt/Komplete Kontrol", ["^NIVSTChildWindow00007.*", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1"],, True)
Standalone.Register("Dubler 2", "Vochlea\sDubler\s2\.1 ahk_class Qt5155QWindowOwnDCIcon", DublerInit, True)
Standalone.Register("Engine", "Best Service Engine ahk_class Engine ahk_exe Engine 2.exe")

ReaHotkey.InitOverlays()

#Include Includes/Plugin.Context.ahk
#Include Includes/Standalone.Context.ahk

SetTimer ReaHotkey.UpdateState, 100
SetTimer ReaHotkey.ManageTimers, 100
SetTimer ReaHotkey.ManageInput, 100
