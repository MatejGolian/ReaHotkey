#Requires AutoHotkey v2.0

Class Sforzando {
    
    Static Init() {
        Plugin.Register("sforzando", "^Plugin[0-9A-F]{17}$", ObjBindMethod(Sforzando, "InitPlugin"), True)
        Standalone.Register("sforzando", "Plogue Art et Technologie, Inc sforzando ahk_class PLGWindowClass ahk_exe sforzando( x64)?.exe", ObjBindMethod(Sforzando, "InitStandalone"))
    }
    
    Static InitPlugin(PluginInstance) {
        PluginHeader := AccessibilityOverlay()
        PluginHeader.AddHotspotButton("Load instrument", 167, 78, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        PluginHeader.AddHotspotButton("Set polyphony", 511, 99, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        PluginHeader.AddHotspotButton("Set pitchbend range", 594, 99, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates)
        PluginInstance.Overlay.Label := "sforzando"
        If PluginInstance.Overlay.ChildControls.Length = 0
        PluginInstance.Overlay.AddAccessibilityOverlay()
        PluginInstance.Overlay.ChildControls[1] := PluginHeader
    }
    
    Static InitStandalone(StandaloneInstance) {
        StandaloneHeader := AccessibilityOverlay()
        StandaloneHeader.AddHotspotButton("Load instrument", 167, 78)
        StandaloneHeader.AddHotspotButton("Set polyphony", 511, 99)
        StandaloneHeader.AddHotspotButton("Set pitchbend range", 594, 99)
        StandaloneInstance.Overlay.Label := "sforzando"
        If StandaloneInstance.Overlay.ChildControls.Length = 0
        StandaloneInstance.Overlay.AddAccessibilityOverlay()
        StandaloneInstance.Overlay.ChildControls[1] := StandaloneHeader
    }
    
}

Sforzando.Init()
