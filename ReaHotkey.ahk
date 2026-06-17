#Requires AutoHotkey v2.0

#MaxThreadsPerHotkey 1
#SingleInstance Force
#Warn All
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
#Include <Configuration>
#Include <ImagePut>
#Include <JXON>
#Include <OCR>
#Include <Program>
#Include <Plugin>
#Include <PluginMenu>
#Include <PluginOverlay>
#Include <ReaHotkey>
#Include <ReaHotkeyMenu>
#Include <Standalone>
#Include <StandaloneMenu>
#Include <StandaloneOverlay>
#Include <Tesseract>
#Include <UIA>
#Include OverlayDesigner/Lib/CodeParser.ahk

ReaHotkey.Init()

#Include Includes/Hotkey.Contexts.ahk
#Include Includes/Hotkey.Functions.ahk
#Include Includes/Overlay.Definitions.ahk
#Include Includes/Overlay.Functions.ahk
#Include *i Includes/CIVersion.ahk
