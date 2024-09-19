#Requires AutoHotkey v2.0

Class FabFilter {
    Static __New() {
        Plugin.Register("FabFilter", "^FF_UIWindow1$", ObjBindMethod(FabFilter, "CreateOverlay"), True)
    }

    Static CreateOverlay(PluginInstance) {
        Ol := AccessibilityOverlay()
        Ol.AddHotspotButton("Presets", 601, 70, CompensatePluginCoordinates,, CompensatePluginCoordinates)
        PluginInstance.Overlay.Label := "FabFilter"
        PluginInstance.Overlay.ChildControls := Array(Ol)
    }
}
