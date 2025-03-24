#Requires AutoHotkey v2.0

Class Repro {
    
    Static __New() {
        Plugin.Register("Repro", "^com.u-he.Repro1.vst.window1$")
        ReproOverlay := AccessibilityOverlay("Repro")
        ReproOverlay.AddHotspotButton("u-HE Logo Menu", 64, 44, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("^U", "Ctrl+U")
        ReproOverlay.AddActivatableCustom("", ObjBindMethod(This, "FocusOrActivateBrowserToggler",, "Focus"),, ObjBindMethod(This, "FocusOrActivateBrowserToggler",, "Activate")).SetHotkey("!B", "Alt+B")
        ReproOverlay.AddHotspotButton("Previous Preset", 440, 53, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("!P", "Alt+P")
        ReproOverlay.AddOCRButton("Presets Menu, currently loaded", "Presets Menu, preset name not detected", "TesseractBest", 460, 36, 670, 70,,, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("!M", "Alt+M")
        ReproOverlay.AddHotspotButton("Next Preset", 730, 53, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("!N", "Alt+N")
        ReproOverlay.AddHotspotButton("Save Preset", 808, 53, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("^S", "Ctrl+S")
        Plugin.RegisterOverlay("Repro", ReproOverlay)
    }
    
    Static DetectWhich() {
        If FindImage("Images/Repro/Repro1.png", GetPluginXCoordinate(), GetPluginYCoordinate(), GetPluginXCoordinate() + 800, GetPluginYCoordinate() + 400) Is Object
        Return "Repro1"
        Else If FindImage("Images/Repro/Repro5.png", GetPluginXCoordinate(), GetPluginYCoordinate(), GetPluginXCoordinate() + 800, GetPluginYCoordinate() + 400) Is Object
        Return "Repro5"
        Else
        Return False
    }
    
    Static FocusOrActivateBrowserToggler(OverlayObj, Action) {
        If This.DetectWhich() = "Repro1" {
            BrowserButton := This.BrowserToggler("Preset Browser Toggle", 310, 87, "0xB3584E", "0x998D80", CompensatePluginCoordinates,, CompensatePluginCoordinates)
            BrowserButton.SetHotkey("!B", "Alt+B")
            If Action = "Focus"
            BrowserButton.Focus()
            Else
            BrowserButton.Activate()
        }
        Else If This.DetectWhich() = "Repro5" {
            BrowserButton := CustomButton("Preset Browser Toggle")
            BrowserButton.SetHotkey("!B", "Alt+B")
            If Action = "Focus"
            BrowserButton.Focus()
            Else
            AccessibilityOverlay.Speak("Toggling the Browser has not been implemented for Repro5 yet.")
        }
        Else {
            AccessibilityOverlay.Speak("Failed to detect Repro version, Preset Browser Toggle unavailable.")
        }
    }
    
    Class BrowserToggler Extends HotspotToggleButton {
        States := Map(-1, "", 0, "disabled", 1, "enabled")
        ExecuteOnActivationPostSpeech() {
            If This.State = 1
            AccessibilityOverlay.Speak("enabled, Use the arrow keys to select a preset.")
        }
    }
    
}
