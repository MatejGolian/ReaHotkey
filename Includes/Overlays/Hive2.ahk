#Requires AutoHotkey v2.0

Class Hive2 {
    
    Static __New() {
        Plugin.Register("Hive 2", "^com.u-he.Hive.vst.window1$")
        Hive2Overlay := PluginOverlay("Hive 2", "Hive 2", KompleteKontrol.CompensatePluginCoordinates)
        Hive2Overlay.AddStaticText("Hive 2")
        Hive2Overlay.AddHotspotButton("u-HE Logo Menu", 1174, 28,,,,, "^U", "Ctrl+U")
        Hive2Overlay.AddControl(This.BrowserToggler("Preset Browser Toggle", 936, 25, "0xCCDFEC", "0x81878D",,,,, "!B", "Alt+B"))
        Hive2Overlay.AddHotspotButton("Previous Preset", 492, 28,,,,, "!P", "Alt+P")
        Hive2Overlay.AddOCRButton("Preset Menu, currently loaded", "Preset Menu, preset name not detected", "TesseractBest", 560, 12, 720, 32,,,,,,, "!M", "Alt+M")
        Hive2Overlay.AddHotspotButton("Next Preset", 756, 28,,,,, "!N", "Alt+N")
        Hive2Overlay.AddHotspotButton("Save Preset", 990, 28,,,,, "^S", "Ctrl+S")
    }
    
    Class BrowserToggler Extends HotspotToggleButton {
        States := Map(-1, "", 0, "disabled", 1, "enabled")
        ExecuteOnActivationPostSpeech() {
            If This.State = 1
            AccessibilityOverlay.Speak("enabled, Use the arrow keys to select a preset.")
        }
    }
    
}
