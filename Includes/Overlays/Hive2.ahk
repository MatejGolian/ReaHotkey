#Requires AutoHotkey v2.0

Class Hive2 {
    
    Static __New() {
        Plugin.Register("Hive 2", "^com.u-he.Hive.vst.window1$")
        Ol := AccessibilityOverlay("Hive 2")
        Ol.AddHotspotButton("u-HE Logo Menu", 1174, 28, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("^U", "Ctrl+U")
        Ol.AddOCRButton("Presets Menu, currently loaded", "Presets Menu, preset name not detected", "TesseractBest", 572, 12, 696, 32,,, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("!M", "Alt+M")
        Ol.AddHotspotButton("Previous Preset", 458, 24, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("!P", "Alt+P")
        Ol.AddHotspotButton("Next Preset", 738, 24, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("!N", "Alt+N")
        Plugin.RegisterOverlay("Hive 2", Ol)
    }
    
}
