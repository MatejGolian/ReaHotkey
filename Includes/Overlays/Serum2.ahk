#Requires AutoHotkey v2.0

Class Serum2 {

    Static __New() {
        Plugin.Register("serum2", "^VSTGUI[0-9A-F]+$", ObjBindMethod(this, "CreateOverlay"), True)
    }

    Static CreateOverlay(PluginInstance) {
        Ol := AccessibilityOverlay()
        Ol.AddHotspotButton("Save Preset As...", 518, 4, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        Ol.AddOCRButton("Presets Menu, currently loaded", "Presets Menu, preset name not detected", "TesseractBest", 540, 13, 608, 23,,, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        Ol.AddHotspotButton("Previous Preset", 938, 4, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        Ol.AddHotspotButton("Next Preset", 968, 4, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        Ol.AddHotspotButton("Main Menu", 1058, 4, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        PluginInstance.Overlay.Label := "Serum 2"
        PluginInstance.Overlay.ChildControls := Array(Ol)
    }
}
