#Requires AutoHotkey v2.0

Class FabFilter {
    Static __New() {
        Plugin.Register("FabFilter", "^FF_UIWindow1$", ObjBindMethod(FabFilter, "CreateOverlay"), True)
    }

    Static CreateOverlay(PluginInstance) {
        Ol := AccessibilityOverlay()
        Ol.AddHotspotButton("Presets", 593, 19, KompleteKontrol.CompensatePluginCoordinates,, KompleteKontrol.CompensatePluginCoordinates)
        PluginInstance.Overlay.Label := "FabFilter"
        PluginInstance.Overlay.ChildControls := Array(Ol)
    }
}
