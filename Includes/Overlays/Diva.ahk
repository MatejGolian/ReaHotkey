#Requires AutoHotkey v2.0

Class Diva {
    
    Static __New() {
        Plugin.Register("Diva", "^com.u-he.Diva.vst.window1$")
        DivaOverlay := PluginOverlay("Diva", "Diva", KompleteKontrol.CompensatePluginCoordinates)
        DivaOverlay.AddStaticText("Diva")
        DivaOverlay.AddHotspotButton("u-HE Logo Menu", 1038, 30,,,,, "^U", "Ctrl+U")
        DivaOverlay.AddControl(This.BrowserToggler("Preset Browser Toggle", 807, 647, "0xAAA89F", "0x7E8086",,,,, "!B", "Alt+B"))
        DivaOverlay.AddHotspotButton("Previous Preset", 458, 30,,,,, "!P", "Alt+P")
        DivaOverlay.AddOCRButton("Preset Menu, currently loaded", "Preset Menu, preset name not detected", "TesseractBest", 480, 16, 720, 44,,,,,,, "!M", "Alt+M")
        DivaOverlay.AddHotspotButton("Next Preset", 738, 30,,,,, "!N", "Alt+N")
        DivaOverlay.AddHotspotButton("Save Preset", 88, 30,,,,, "^S", "Ctrl+S")
    }
    
    Class BrowserToggler Extends HotspotToggleButton {
        States := Map(-1, "", 0, "disabled", 1, "enabled")
        ExecuteOnActivationPostSpeech() {
            If This.State = 1
            AccessibilityOverlay.Speak("enabled, Use the arrow keys to select a preset.")
        }
    }
    
}
