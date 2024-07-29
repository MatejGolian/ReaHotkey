#Requires AutoHotkey v2.0

#MaxThreadsPerHotkey 1
#SingleInstance Force
#Warn All
CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"
InstallKeybdHook
SendMode "Input"
SetTitleMatchMode "RegEx"
SetWorkingDir A_InitialWorkingDir

#Include <AccessibilityOverlay>
#Include <AccessibleMenu>
#Include <AccessiblePluginMenu>
#Include <AccessibleStandaloneMenu>
#Include <JXON>
#Include <OCR>
#Include <Plugin>
#Include <ReaHotkey>
#Include <Standalone>
#Include <UIA>

A_IconTip := "ReaHotkey"
A_TrayMenu.Delete
A_TrayMenu.Add("&Configuration...", ReaHotkey.ShowConfigBox)
A_TrayMenu.Add("&Pause", ReaHotkey.TogglePause)
A_TrayMenu.Add("&Reload", ReaHotkey.Reload)
A_TrayMenu.Add("&View Readme", ReaHotkey.ViewReadme)
A_TrayMenu.Add("&About...", ReaHotkey.ShowAboutBox)
A_TrayMenu.Add("&Quit", ReaHotkey.Quit)
A_TrayMenu.Default := "&Configuration..."

AccessibilityOverlay.Speak("ReaHotkey ready")
SetTimer ReaHotkey.ManageState, 100

#Include Includes/Plugin.Context.ahk
#IncludeAgain Includes/Global.Context.ahk
#Include Includes/Standalone.Context.ahk
#IncludeAgain Includes/Global.Context.ahk
#Include Includes/Overlay.Definitions.ahk
#Include Includes/Overlay.Functions.ahk
#Include Includes/Version.ahk
#Include *i Includes/CIVersion.ahk
