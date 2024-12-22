#Requires AutoHotkey v2.0

Class ImpactSoundworks {
    
    Static __New() {
        PluginClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
        Kontakt7XOffset := 0
        Kontakt7YOffset := 0
        Kontakt8XOffset := 0
        Kontakt8YOffset := 29
        KompleteKontrolXOffset := 190
        KompleteKontrolYOffset := 111
        
        JuggernautBassOverlay := AccessibilityOverlay("Juggernaut")
        JuggernautBassOverlay.Metadata := Map("Vendor", "Impact Soundworks", "Product", "Juggernaut", "Patch", "BASS Juggernaut.nki", "Image", Map("File", "Images/KontaktKompleteKontrol/Juggernaut/Bass.png"))
        JuggernautBassOverlay.AddAccessibilityOverlay()
        JuggernautBassOverlay.AddStaticText("Juggernaut Bass")
        JuggernautBassOverlay.AddControl(This.OCRButton("Preset", "Unknown", %PluginClass%XOffset + 354, %PluginClass%YOffset + 125, %PluginClass%XOffset + 562, %PluginClass%YOffset + 175,,, CompensatePluginCoordinates,, CompensatePluginCoordinates))
        %PluginClass%.PluginOverlays.Push(JuggernautBassOverlay)
        
        JuggernautDrumsAndFXOverlay := AccessibilityOverlay("Juggernaut")
        JuggernautDrumsAndFXOverlay.Metadata := Map("Vendor", "Impact Soundworks", "Product", "Juggernaut", "Patch", "DRUMS & FX Juggernaut v1.15.nki", "Image", Map("File", "Images/KontaktKompleteKontrol/Juggernaut/DrumsAndFX.png"))
        JuggernautDrumsAndFXOverlay.AddAccessibilityOverlay()
        JuggernautDrumsAndFXOverlay.AddStaticText("Juggernaut Drums & FX")
        JuggernautDrumsAndFXOverlay.AddControl(This.OCRButton("Preset", "Unknown", %PluginClass%XOffset + 150, %PluginClass%YOffset + 132, %PluginClass%XOffset + 360, %PluginClass%YOffset + 170,,, CompensatePluginCoordinates,, CompensatePluginCoordinates))
        %PluginClass%.PluginOverlays.Push(JuggernautDrumsAndFXOverlay)
    }
    
    Class OCRButton Extends OCRButton {
        
        DefaultLabel := ""
        DefaultOCRString := ""
        
        __New(Label, DefaultOCRString, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage := "", OCRScale := 1, PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "") {
            Super.__New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage, OCRScale, PreExecFocusFunctions, PostExecFocusFunctions, PreExecActivationFunctions, PostExecActivationFunctions)
            This.Label := Label
            This.DefaultOCRString := DefaultOCRString
        }
        
        SpeakOnActivation(Speak := True) {
            Message := ""
            CheckResult := This.GetState()
            LabelString := This.Label
            If LabelString = ""
            LabelString := This.DefaultLabel
            OCRString := AccessibilityOverlay.OCR(This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, This.OCRLanguage, This.OCRScale)
            If OCRString = ""
            OCRString := This.DefaultOCRString
            StateString := ""
            If This.States.Has(CheckResult)
            StateString := This.States[CheckResult]
            If not This.ControlID = AccessibilityOverlay.PreviousControlID
            Message := LabelString . " " . OCRString . " " . This.ControlTypeLabel . " " . StateString
            Else
            If This.States.Count > 1
            Message := StateString
            If Speak
            AccessibilityOverlay.Speak(Message)
        }
        
        SpeakOnFocus(Speak := True) {
            Message := ""
            CheckResult := This.GetState()
            LabelString := This.Label
            If LabelString = ""
            LabelString := This.DefaultLabel
            OCRString := AccessibilityOverlay.OCR(This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, This.OCRLanguage, This.OCRScale)
            If OCRString = ""
            OCRString := This.DefaultOCRString
            StateString := ""
            If This.States.Has(CheckResult)
            StateString := This.States[CheckResult]
            If not This.ControlID = AccessibilityOverlay.PreviousControlID Or (This.GetMasterControl() Is AccessibilityOverlay And This.GetMasterControl().GetFocusableControlIDs().Length = 1)
            Message := LabelString . " " . OCRString . " " . This.ControlTypeLabel . " " . StateString . " " . This.HotkeyLabel
            If Speak
            AccessibilityOverlay.Speak(Message)
        }
        
    }
    
}
