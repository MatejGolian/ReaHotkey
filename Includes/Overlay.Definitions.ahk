#Requires AutoHotkey v2.0

Plugin.DefaultOverlay := AccessibilityOverlay()
Plugin.DefaultOverlay.AddStaticText("No overlay defined")
Plugin.ChooserOverlay := AccessibilityOverlay()
Plugin.ChooserOverlay.AddCustomButton("Choose overlay",,, ActivateChooser).SetHotkey("!C", "Alt+C")

Standalone.DefaultOverlay := AccessibilityOverlay()
Standalone.DefaultOverlay.AddStaticText("No overlay defined")
Standalone.ChooserOverlay := AccessibilityOverlay()
Standalone.ChooserOverlay.AddCustomButton("Choose overlay",,, ActivateChooser).SetHotkey("!C", "Alt+C")

#Include Overlays/Kontakt7.ahk
#Include Overlays/Kontakt8.ahk
#Include Overlays/KompleteKontrol.ahk
#Include Overlays/Diva.ahk
#Include Overlays/Dubler2.ahk
#Include Overlays/FabFilter.ahk
#Include Overlays/Hive2.ahk
#Include Overlays/Repro.ahk
#Include Overlays/Sforzando.ahk
#Include Overlays/ZebraLegacy.ahk
#Include Overlays/Engine2.ahk
#Include Overlays/Raum.ahk
#Include Overlays/Serum2.ahk
#Include Overlays/Zampler.ahk
