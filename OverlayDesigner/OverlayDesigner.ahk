#Requires AutoHotkey v2.0

#SingleInstance Force
#Warn
#Warn LocalSameAsGlobal, Off
CoordMode "Caret", "Client"
CoordMode "Menu", "Client"
CoordMode "Mouse", "Client"
CoordMode "Pixel", "Client"
CoordMode "ToolTip", "Client"
SendMode "Input"
SetTitleMatchMode 2

#Include ../Lib/AccessibilityOverlay.ahk
#Include ../Lib/Configuration.ahk
#Include ../Lib/ImagePut.ahk
#Include ../Lib/JXON.ahk
#Include ../Lib/OCR.ahk
#Include ../Lib/Program.ahk
#Include ../Lib/Plugin.ahk
#Include ../Lib/PluginMenu.ahk
#Include ../Lib/PluginOverlay.ahk
#Include ../Lib/ReaHotkey.ahk
#Include ../Lib/ReaHotkeyMenu.ahk
#Include ../Lib/Standalone.ahk
#Include ../Lib/StandaloneMenu.ahk
#Include ../Lib/StandaloneOverlay.ahk
#Include ../Lib/Tesseract.ahk
#Include ../Lib/UIA.ahk

#Include Lib/Editor.ahk
#Include Lib/SpecialControls.ahk

#Include ../Includes/Overlay.Functions.ahk
#Include Includes/Helper.Functions.ahk
#Include Includes/Hotkey.Functions.ahk
#Include Includes/Menu.Handlers.ahk
#Include Includes/Overlay.Functions.ahk
#Include Includes/ScreenArea2File.ahk

#HotIf
Editor.Init()

#Include ../Includes/Version.ahk
#Include *i ../Includes/CIVersion.ahk
;@Ahk2Exe-SetDescription OverlayDesigner
;@Ahk2Exe-SetProductName OverlayDesigner
