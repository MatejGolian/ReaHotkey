#Requires AutoHotkey v2.0

#MaxThreadsPerHotkey 1
#SingleInstance Force
#Warn All
#Warn LocalSameAsGlobal, Off
CoordMode "Caret", "Client"
CoordMode "Menu", "Client"
CoordMode "Mouse", "Client"
CoordMode "Pixel", "Client"
CoordMode "ToolTip", "Client"
InstallKeybdHook
SendMode "Input"
SetTitleMatchMode "RegEx"

#Include Includes/Version.ahk
#Include <AccessibilityOverlay>
#Include <AccessibleMenu>
#Include <AccessiblePluginMenu>
#Include <AccessibleStandaloneMenu>
#Include <Configuration>
#Include <ImagePut>
#Include <JXON>
#Include <OCR>
#Include <Program>
#Include <Plugin>
#Include <ReaHotkey>
#Include <Standalone>
#Include <Tesseract>
#Include <UIA>

A_IconTip := "ReaHotkey"
A_TrayMenu.Delete
A_TrayMenu.Add("&Configuration...", ObjBindMethod(ReaHotkey, "ShowConfigBox"))
A_TrayMenu.Add("&Pause", ObjBindMethod(ReaHotkey, "TogglePause"))
A_TrayMenu.Add("&Reload", ObjBindMethod(ReaHotkey, "Reload"))
A_TrayMenu.Add("&View Readme", ObjBindMethod(ReaHotkey, "ViewReadme"))
A_TrayMenu.Add("Check for &updates...", ObjBindMethod(ReaHotkey, "CheckForUpdates"))
A_TrayMenu.Add("&About...", ObjBindMethod(ReaHotkey, "ShowAboutBox"))
A_TrayMenu.Add("&Quit", ObjBindMethod(ReaHotkey, "Quit"))
A_TrayMenu.Default := "&Configuration..."

#Include Includes/Hotkey.Contexts.ahk
#Include Includes/Hotkey.Functions.ahk
#Include Includes/Overlay.Definitions.ahk
#Include Includes/Overlay.Functions.ahk
#Include *i Includes/CIVersion.ahk
