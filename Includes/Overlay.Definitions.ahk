#Requires AutoHotkey v2.0

Plugin.DefaultOverlay := AccessibilityOverlay()
Plugin.DefaultOverlay.AddStaticText("No overlay defined")
Plugin.ChooserOverlay := AccessibilityOverlay()
Plugin.ChooserOverlay.AddCustomButton("Choose overlay",,, ChoosePluginOverlay).SetHotkey("!C", "Alt+C")

Standalone.DefaultOverlay := AccessibilityOverlay()
Standalone.DefaultOverlay.AddStaticText("No overlay defined")
Standalone.ChooserOverlay := AccessibilityOverlay()
Standalone.ChooserOverlay.AddCustomButton("Choose overlay",,, ChooseStandaloneOverlay).SetHotkey("!C", "Alt+C")

#Include Overlays/Dubler2.ahk
#Include Overlays/Engine2.ahk
#Include Overlays/FabFilter.ahk
#Include Overlays/KompleteKontrol.ahk
#Include Overlays/Kontakt.ahk
#Include Overlays/Sforzando.ahk
