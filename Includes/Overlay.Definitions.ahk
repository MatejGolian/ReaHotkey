#Requires AutoHotkey v2.0

Plugin.DefaultOverlay := AccessibilityOverlay()
Plugin.DefaultOverlay.AddStaticText("No overlay defined")
Plugin.ChooserOverlay := AccessibilityOverlay()
Plugin.ChooserOverlay.AddCustomButton("Choose overlay",, ChoosePluginOverlay)

Standalone.DefaultOverlay := AccessibilityOverlay()
Standalone.DefaultOverlay.AddStaticText("No overlay defined")
Standalone.ChooserOverlay := AccessibilityOverlay()
Standalone.ChooserOverlay.AddCustomButton("Choose overlay",, ChooseStandaloneOverlay)

#Include Overlays/Dubler2.ahk
#Include Overlays/Engine2.ahk
#Include Overlays/KompleteKontrol.ahk
#Include Overlays/Kontakt.ahk
#Include Overlays/Sforzando.ahk
