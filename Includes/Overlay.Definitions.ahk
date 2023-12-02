#Requires AutoHotkey v2.0

Plugin.DefaultOverlay := AccessibilityOverlay()
Plugin.DefaultOverlay.AddStaticText("No overlay defined")
Plugin.ChooserOverlay := AccessibilityOverlay()
Plugin.ChooserOverlay.AddAccessibilityOverlay()
Plugin.ChooserOverlay.AddCustomButton("Choose overlay",, ChoosePluginOverlay)

Standalone.DefaultOverlay := AccessibilityOverlay()
Standalone.DefaultOverlay.AddStaticText("No overlay defined")
Standalone.ChooserOverlay := AccessibilityOverlay()
Standalone.ChooserOverlay.AddAccessibilityOverlay()
Standalone.ChooserOverlay.AddCustomButton("Choose overlay",, ChooseStandaloneOverlay)

#Include Overlays/Engine.ahk
#Include Overlays/KontaktKompleteKontrol.ahk
