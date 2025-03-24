#Requires AutoHotkey v2.0

Class Repro {
    
    Static __New() {
        Plugin.Register("Repro", "^com.u-he.Repro1.vst.window1$")
        ReproOverlay := AccessibilityOverlay("Repro")
        ReproOverlay.AddHotspotButton("u-HE Logo Menu", 64, 44, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("^U", "Ctrl+U")
        ReproOverlay.AddHotspotButton("Previous Preset", 440, 53, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("!P", "Alt+P")
        ReproOverlay.AddOCRButton("Presets Menu, currently loaded", "Presets Menu, preset name not detected", "TesseractBest", 460, 36, 670, 70,,, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("!M", "Alt+M")
        ReproOverlay.AddHotspotButton("Next Preset", 730, 53, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("!N", "Alt+N")
        ReproOverlay.AddHotspotButton("Save Preset", 808, 53, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("^S", "Ctrl+S")
        Plugin.RegisterOverlay("Repro", ReproOverlay)
    }
    
}
