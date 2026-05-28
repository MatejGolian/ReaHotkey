#Requires AutoHotkey v2.0

Class GTune {
    
    Static __New() {
        Plugin.Register("GTune", "^GWinClass_[0-9A-F]{1,}$", False, False, 1, False, False)
        Plugin.SetTimer("GTune", This.AutoReport, 400)
        
        GTuneOverlay := PluginOverlay()
        GTuneOverlay.AddOCRButton("Reference frequency", "Reference frequency Unknown", "TesseractBest", 237, 37, 287, 47)
        GTuneOverlay.AddActivatableCustom("Tune",, ObjBindMethod(This, "FocusTune"),, ObjBindMethod(This, "ActivateTune"))
        
        Plugin.RegisterOverlay("GTune", GTuneOverlay)
    }
    
    Static ActivateTune(OverlayObj) {
        AccessibilityOverlay.Speak(This.GetTune())
    }
    
    Static FocusTune(OverlayObj) {
        AccessibilityOverlay.Speak(OverlayObj.Label . " " . This.GetTune())
    }
    
    Static GetTune() {
        PluginControlPos := GetPluginControlPos()
        Result := Trim(AccessibilityOverlay.Helpers.OCR("TesseractBest", PluginControlPos.X + 177, PluginControlPos.Y + 225, PluginControlPos.X + 277, PluginControlPos.Y + 245))
        If Result = ""
        Return "No signal"
        If Result = "1"
        Return "No signal"
        If Result = "i"
        Return "No signal"
        Return Result
    }
    
    Class AutoReport {
        Static Call() {
            Static PreviousValue := ""
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            CurrentValue := %ParentClass%.GetTune()
            If Not CurrentValue = "No signal" And Not CurrentValue = PreviousValue {
                PreviousValue := CurrentValue
                AccessibilityOverlay.Speak(CurrentValue)
            }
        }
    }
    
}
