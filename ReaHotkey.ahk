#Requires AutoHotkey v2.0

#MaxThreadsPerHotkey 1
#SingleInstance Force
#Warn All
CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"
SendMode "Input"
SetTitleMatchMode "RegEx"
SetWorkingDir A_InitialWorkingDir

#Include <AccessibilityOverlay>
#Include <AccessibleMenu>
#Include <OCR>
#Include <Plugin>
#Include <ReaHotkey>
#Include <Standalone>

A_IconTip := "ReaHotkey"
A_TrayMenu.Delete
A_TrayMenu.Add("&Pause", ReaHotkey.TogglePause)
A_TrayMenu.Add("&Close", ReaHotkey.Close)

AccessibilityOverlay.Speak("ReaHotkey ready")

ReaHotkey.TurnPluginHotkeysOff()
ReaHotkey.TurnStandaloneHotkeysOff()
OnError ReaHotkey.HandleError
SetTimer ReaHotkey.ManageState, 100

#Include Includes/Plugin.Context.ahk
#Include Includes/Standalone.Context.ahk
#Include Includes/Overlay.Definitions.ahk
#Include Includes/Overlay.Functions.ahk
