#Requires AutoHotkey v2.0

Class ZebraLegacy {
    
    Static __New() {
        Plugin.Register("Zebra2", "^com.u-he.Zebra2.vst.window1$")
        Zebra2Overlay := AccessibilityOverlay("Zebra2")
        Zebra2Overlay.AddStaticText("Zebra2")
        Zebra2Overlay.AddHotspotButton("u-HE Logo Menu", 1056, 28, KompleteKontrol.CompensatePluginCoordinates,, KompleteKontrol.CompensatePluginCoordinates).SetHotkey("^U", "Ctrl+U")
        Zebra2Overlay.AddHotspotButton("Previous Preset", 420, 28, KompleteKontrol.CompensatePluginCoordinates,, KompleteKontrol.CompensatePluginCoordinates).SetHotkey("!P", "Alt+P")
        Zebra2Overlay.AddOCRButton("Preset Menu, currently loaded", "Preset Menu, preset name not detected", "TesseractBest", 440, 16, 670, 40,,, KompleteKontrol.CompensatePluginCoordinates,, KompleteKontrol.CompensatePluginCoordinates).SetHotkey("!M", "Alt+M")
        Zebra2Overlay.AddHotspotButton("Next Preset", 760, 28, KompleteKontrol.CompensatePluginCoordinates,, KompleteKontrol.CompensatePluginCoordinates).SetHotkey("!N", "Alt+N")
        Zebra2Overlay.AddHotspotButton("Save Preset", 922, 28, KompleteKontrol.CompensatePluginCoordinates,, KompleteKontrol.CompensatePluginCoordinates).SetHotkey("^S", "Ctrl+S")
        Plugin.RegisterOverlay("Zebra2", Zebra2Overlay)
        Plugin.Register("ZebraHZ", "com.u-he.ZebraHZ.vst.window1")
        ZebraHZOverlay := AccessibilityOverlay("ZebraHZ")
        ZebraHZOverlay.AddStaticText("ZebraHZ")
        ZebraHZOverlay.AddHotspotButton("u-HE Logo Menu", 1048, 28, KompleteKontrol.CompensatePluginCoordinates,, KompleteKontrol.CompensatePluginCoordinates).SetHotkey("^U", "Ctrl+U")
        ZebraHZOverlay.AddHotspotButton("Previous Preset", 420, 28, KompleteKontrol.CompensatePluginCoordinates,, KompleteKontrol.CompensatePluginCoordinates).SetHotkey("!P", "Alt+P")
        ZebraHZOverlay.AddOCRButton("Preset Menu, currently loaded", "Preset Menu, preset name not detected", "TesseractBest", 440, 16, 670, 40,,, KompleteKontrol.CompensatePluginCoordinates,, KompleteKontrol.CompensatePluginCoordinates).SetHotkey("!M", "Alt+M")
        ZebraHZOverlay.AddHotspotButton("Next Preset", 690, 28, KompleteKontrol.CompensatePluginCoordinates,, KompleteKontrol.CompensatePluginCoordinates).SetHotkey("!N", "Alt+N")
        ZebraHZOverlay.AddHotspotButton("Save Preset", 760, 28, KompleteKontrol.CompensatePluginCoordinates,, KompleteKontrol.CompensatePluginCoordinates).SetHotkey("^S", "Ctrl+S")
        Plugin.RegisterOverlay("ZebraHZ", ZebraHZOverlay)
    }
    
}
