#Requires AutoHotkey v2.0

#MaxThreadsPerHotkey 1
#SingleInstance Force
#Warn All
SendMode "Input"
SetTitleMatchMode "RegEx"
SetWorkingDir A_InitialWorkingDir
CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"

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

#Include Includes/Overlay.Definitions.ahk
#Include Includes/Overlay.Functions.ahk
#Include Includes/Plugin.Context.ahk
#Include Includes/Standalone.Context.ahk

SetTimer ReaHotkey.UpdateState, 100
SetTimer ReaHotkey.ManageTimers, 100
SetTimer ReaHotkey.ManageInput, 100
