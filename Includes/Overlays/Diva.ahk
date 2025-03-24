#Requires AutoHotkey v2.0

Class Diva {
    
    Static __New() {
        Plugin.Register("Diva", "^com.u-he.Diva.vst.window1$")
        DivaOverlay := AccessibilityOverlay("Diva")
        DivaOverlay.AddHotspotButton("u-HE Logo Menu", 1038, 30, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("^U", "Ctrl+U")
        DivaOverlay.AddHotspotButton("Previous Preset", 458, 30, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("!P", "Alt+P")
        DivaOverlay.AddOCRButton("Presets Menu, currently loaded", "Presets Menu, preset name not detected", "TesseractBest", 480, 16, 720, 44,,, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("!M", "Alt+M")
        DivaOverlay.AddHotspotButton("Next Preset", 738, 30, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("!N", "Alt+N")
        DivaOverlay.AddHotspotButton("Save Preset", 88, 30, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("^S", "Ctrl+S")
        Plugin.RegisterOverlay("Diva", DivaOverlay)
    }
    
}
