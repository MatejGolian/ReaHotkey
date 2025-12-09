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
#Include <PluginOverlay>
#Include <ReaHotkey>
#Include <Standalone>
#Include <StandaloneOverlay>
#Include <Tesseract>
#Include <UIA>

#Include Includes/Hotkey.Contexts.ahk
#Include Includes/Hotkey.Functions.ahk
#Include Includes/Overlay.Definitions.ahk
#Include Includes/Overlay.Functions.ahk
#Include *i Includes/CIVersion.ahk
