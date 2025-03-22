#Requires AutoHotkey v2.0

Class Serum2 {
    
    Static __New() {
        Plugin.Register("Serum 2", "^VSTGUI[0-9A-F]+$")
        Ol := AccessibilityOverlay("Serum 2")
        Ol.AddHotspotButton("Main Menu", 1058, 4, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("^M", "Ctrl+M")
        Ol.AddHotspotButton("Save Preset As...", 518, 4, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("^S", "Ctrl+S")
        Ol.AddOCRButton("Presets Menu, currently loaded", "Presets Menu, preset name not detected", "TesseractBest", 540, 13, 608, 23,,, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("!M", "Alt+M")
        Ol.AddHotspotButton("Previous Preset", 938, 4, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("!P", "Alt+P")
        Ol.AddHotspotButton("Next Preset", 968, 4, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("!N", "Alt+N")
        Plugin.RegisterOverlay("Serum 2", Ol)
    }
    
}
