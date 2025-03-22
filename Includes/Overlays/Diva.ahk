#Requires AutoHotkey v2.0

Class Diva {

    Static __New() {
        Plugin.Register("Diva", "^com.u-he.Diva.vst.window1$", ObjBindMethod(this, "CreateOverlay"), True)
    }

    Static CreateOverlay(PluginInstance) {
        Ol := AccessibilityOverlay()
        Ol.AddHotspotButton("Previous Preset", 458, 24, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        Ol.AddOCRButton("Presets Menu, currently loaded", "Presets Menu, preset name not detected", "TesseractBest", 503, 30, 697, 45,,, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        Ol.AddHotspotButton("Next Preset", 738, 24, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        Ol.AddHotspotButton("u-HE Logo Menu", 1038, 24, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        PluginInstance.Overlay.Label := "Serum 2"
        PluginInstance.Overlay.ChildControls := Array(Ol)
    }
}
