#Requires AutoHotkey v2.0

Class Diva {
    
    Static __New() {
        Plugin.Register("Diva", "^com.u-he.Diva.vst.window1$")
        Ol := AccessibilityOverlay("Diva")
        Ol.AddHotspotButton("u-HE Logo Menu", 1038, 24, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("^U", "Ctrl+U")
        Ol.AddOCRButton("Presets Menu, currently loaded", "Presets Menu, preset name not detected", "TesseractBest", 503, 30, 697, 45,,, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("!M", "Alt+M")
        Ol.AddHotspotButton("Previous Preset", 458, 24, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("!P", "Alt+P")
        Ol.AddHotspotButton("Next Preset", 738, 24, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("!N", "Alt+N")
        Plugin.RegisterOverlay("Diva", Ol)
        }
    
}
