#Requires AutoHotkey v2.0

#MaxThreadsPerHotkey 1
#SingleInstance Force
#Warn All
CoordMode "Caret", "Window"
CoordMode "Menu", "Window"
CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"
InstallKeybdHook
SendMode "Input"
SetTitleMatchMode "RegEx"

#Include Includes/Version.ahk
#Include <AccessibilityOverlay>
#Include <AccessibleMenu>
#Include <AccessiblePluginMenu>
#Include <AccessibleStandaloneMenu>
#Include <JXON>
#Include <OCR>
#Include <Program>
#Include <Plugin>
#Include <ReaHotkey>
#Include <Standalone>
#Include <UIA>
#Include <Update>

A_IconTip := "ReaHotkey"
A_TrayMenu.Delete
A_TrayMenu.Add("&Configuration...", ReaHotkey.ShowConfigBox)
A_TrayMenu.Add("&Pause", ReaHotkey.TogglePause)
A_TrayMenu.Add("&Reload", ReaHotkey.Reload)
A_TrayMenu.Add("&View Readme", ReaHotkey.ViewReadme)
A_TrayMenu.Add("Check for &updates...", ReaHotkey.CheckForUpdates)
A_TrayMenu.Add("&About...", ReaHotkey.ShowAboutBox)
A_TrayMenu.Add("&Quit", ReaHotkey.Quit)
A_TrayMenu.Default := "&Configuration..."

AccessibilityOverlay.Speak("ReaHotkey ready")

#Include Includes/Hotkey.Contexts.ahk
#Include Includes/Hotkey.Functions.ahk
#Include Includes/Overlay.Definitions.ahk
#Include Includes/Overlay.Functions.ahk
#Include *i Includes/CIVersion.ahk
